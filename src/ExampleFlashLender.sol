// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC3156FlashBorrower.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC3156FlashLender.sol";

import "./interfaces/IERC6680.sol";

contract ExampleFlashLender is IERC6680, IERC3156FlashLender {
    uint256 internal _feePerNFT;
    address internal _flashFeeToken;

    constructor(uint256 feePerNFT_, address flashFeeToken_) {
        _feePerNFT = feePerNFT_;
        _flashFeeToken = flashFeeToken_;
    }

    function flashFeeToken() public view returns (address) {
        return _flashFeeToken;
    }

    function availableForFlashLoan(address token, uint256 tokenId) public view returns (bool) {
        // return if the NFT is owned by this contract
        try IERC721(token).ownerOf(tokenId) returns (address result) {
            return result == address(this);
        } catch {
            return false;
        }
    }

    function flashFee(address token, uint256 tokenId) public view returns (uint256) {
        return _feePerNFT;
    }

    function flashLoan(IERC3156FlashBorrower receiver, address token, uint256 tokenId, bytes calldata data)
        public
        returns (bool)
    {
        // check that the NFT is available for a flash loan
        require(availableForFlashLoan(token, tokenId), "IERC6680: NFT not available for flash loan");

        // transfer the NFT to the borrower
        IERC721(token).safeTransferFrom(address(this), address(receiver), tokenId);

        // calculate the fee
        uint256 fee = flashFee(token, tokenId);

        // call the borrower
        bool success =
            receiver.onFlashLoan(msg.sender, token, tokenId, fee, data) == keccak256("ERC3156FlashBorrower.onFlashLoan");

        // check that flashloan was successful
        require(success, "IERC6680: Flash loan failed");

        // check that the NFT was returned by the borrower
        require(IERC721(token).ownerOf(tokenId) == address(this), "IERC6680: NFT not returned by borrower");

        // transfer the fee from the borrower
        IERC20(flashFeeToken()).transferFrom(msg.sender, address(this), fee);

        return success;
    }

    function maxFlashLoan(address token) public pure override returns (uint256) {
        // if a contract also supports flash loans for ERC20 tokens then it can
        // return some value here instead of 0
        return 0;
    }

    function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
