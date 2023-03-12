// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface INFTFlashLender {
    /// @dev Whether or not the NFT is available for a flash loan.
    /// @param token The address of the NFT contract.
    /// @param tokenId The ID of the NFT.
    /// @return True if the NFT is available to be flash borrowed.
    function availableForFlashLoan(address token, uint256 tokenId) external view returns (bool);

    /// @dev Calculates the fee (in a given currency) to be paid when an NFT is flash borrowed.
    /// @param token The address of the NFT contract.
    /// @param tokenId The ID of the NFT.
    /// @param feeToken The address of the token to be used to pay the fee.
    /// @return The fee to be paid to flash borrow the NFT.
    function flashFee(address token, uint256 tokenId, address feeToken) external view returns (uint256);

    /// @dev Flash loans an NFT.
    /// @param receiver The address that will receive the NFT.
    /// @param token The address of the NFT contract.
    /// @param tokenId The ID of the NFT.
    /// @param data The data to be passed to the receiver.
    /// @return True if the NFT was successfully flash loaned.
    function flashLoan(address receiver, address token, uint256 tokenId, bytes calldata data) external returns (bool);
}
