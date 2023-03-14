// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "openzeppelin-contracts/contracts/interfaces/IERC20.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC721.sol";
import "openzeppelin-contracts/contracts/interfaces/IERC3156FlashBorrower.sol";

import "./ExampleFlashLender.sol";

contract ExampleFlashBorrower is IERC3156FlashBorrower {
    ExampleFlashLender public lender;

    constructor(ExampleFlashLender lender_) {
        lender = lender_;
    }

    function initiateFlashLoan(address token, uint256 tokenId, bytes calldata data) public {
        lender.flashLoan(this, token, tokenId, data);
    }

    function onFlashLoan(address initiator, address token, uint256 tokenId, uint256 fee, bytes calldata data)
        public
        override
        returns (bytes32)
    {
        require(msg.sender == address(lender), "NFTFlashBorrower: untrusted lender");
        require(initiator == address(this), "NFTFlashBorrower: untrusted initiator");

        // do some stuff with the NFT
        // ... stuff stuff stuff
        // ... stuff stuff stuff

        // return the NFT back to the lender
        IERC721(token).safeTransferFrom(address(this), msg.sender, tokenId);

        // approve the lender to take the fee from this contract
        IERC20(lender.flashFeeToken()).approve(msg.sender, fee);

        return keccak256("ERC3156FlashBorrower.onFlashLoan");
    }

    function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
