// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "solmate/tokens/ERC721.sol";
import "solmate/tokens/ERC20.sol";

import "./interfaces/INFTFlashLender.sol";
import "./interfaces/INFTFlashBorrower.sol";

contract ExampleFlashBorrower is INFTFlashBorrower, ERC721TokenReceiver {
    INFTFlashLender public lender;

    constructor(INFTFlashLender _lender) {
        lender = _lender;
    }

    function initiateFlashLoan(address token, uint256 tokenId, bytes calldata data) external {
        lender.flashLoan(this, token, tokenId, data);
    }

    function onFlashLoan(address initiator, address token, uint256 tokenId, uint256 fee, bytes calldata data)
        external
        override
        returns (bytes32)
    {
        require(msg.sender == address(lender), "NFTFlashBorrower: untrusted lender");
        require(initiator == address(this), "NFTFlashBorrower: untrusted initiator");

        // do some stuff with the NFT
        // ... stuff stuff stuff
        // ... stuff stuff stuff

        // return the NFT back to the lender
        ERC721(token).safeTransferFrom(address(this), msg.sender, tokenId);

        // approve the lender to take the fee from this contract
        ERC20(lender.flashFeeToken()).approve(msg.sender, fee);

        return keccak256("NFTFlashBorrower.onFlashLoan");
    }
}
