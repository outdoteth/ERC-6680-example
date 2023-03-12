// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface INFTFlashBorrower {
    /// @dev Called by the NFT flash lender when an NFT is flash borrowed.
    /// @param initiator The address that initiated the flash loan.
    /// @param token The address of the NFT contract.
    /// @param tokenId The ID of the NFT.
    /// @param fee The fee to be paid to flash borrow the NFT.
    /// @param feeToken The address of the token to be used to pay the fee.
    /// @param data The data passed to the receiver.
    /// @return The keccak256 hash of "NFTFlashBorrower.onFlashLoan"
    function onFlashLoan(
        address initiator,
        address token,
        uint256 tokenId,
        uint256 fee,
        address feeToken,
        bytes calldata data
    ) external returns (bytes32);
}
