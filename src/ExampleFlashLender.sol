// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "solmate/tokens/ERC721.sol";
import "solmate/tokens/ERC20.sol";

import "./interfaces/INFTFlashLender.sol";
import "./interfaces/INFTFlashBorrower.sol";

contract ExampleFlashLender is INFTFlashLender, ERC721TokenReceiver {
    uint256 public feePerNFT;
    address public flashFeeToken;

    constructor(uint256 _feePerNFT, address _flashFeeToken) {
        feePerNFT = _feePerNFT;
        flashFeeToken = _flashFeeToken;
    }

    function availableForFlashLoan(address token, uint256 tokenId) public view returns (bool) {
        try ERC721(token).ownerOf(tokenId) returns (address result) {
            return result == address(this);
        } catch {
            return false;
        }
    }

    function flashFee(address token, uint256 tokenId) public view returns (uint256) {
        return feePerNFT;
    }

    function flashLoan(INFTFlashBorrower receiver, address token, uint256 tokenId, bytes calldata data)
        external
        returns (bool)
    {
        // check that the NFT is available for a flash loan
        require(availableForFlashLoan(token, tokenId), "NFTFlashLender: NFT not available for flash loan");

        // transfer the NFT to the borrower
        ERC721(token).safeTransferFrom(address(this), address(receiver), tokenId);

        // calculate the fee
        uint256 fee = flashFee(token, tokenId);

        // call the borrower
        bool success =
            receiver.onFlashLoan(msg.sender, token, tokenId, fee, data) == keccak256("ERC3156FlashBorrower.onFlashLoan");

        // check that the NFT was returned by the borrower
        require(ERC721(token).ownerOf(tokenId) == address(this), "NFTFlashLender: NFT not returned by borrower");

        // transfer the fee from the borrower
        ERC20(flashFeeToken).transferFrom(msg.sender, address(this), fee);

        return success;
    }
}
