// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./INFTFlashBorrower.sol";

interface INFTFlashLender {
    /// @dev The address of the token used to pay flash loan fees.
    function flashFeeToken() external view returns (address);

    /// @dev Whether or not the NFT is available for a flash loan.
    /// @param token The address of the NFT contract.
    /// @param tokenId The ID of the NFT.
    function availableForFlashLoan(address token, uint256 tokenId) external view returns (bool);

    /// @dev Calculates the fee (in a given currency) to be paid when an NFT is flash borrowed.
    /// @param token The address of the NFT contract.
    /// @param tokenId The ID of the NFT.
    /// @return The fee to be paid to flash borrow the NFT.
    function flashFee(address token, uint256 tokenId) external view returns (uint256);

    /// @dev Flash loans an NFT.
    /// @param receiver The address that will receive the NFT.
    /// @param token The address of the NFT contract.
    /// @param tokenId The ID of the NFT.
    /// @param data The data to be passed to the receiver.
    /// @return True if the NFT was successfully flash loaned.
    function flashLoan(INFTFlashBorrower receiver, address token, uint256 tokenId, bytes calldata data)
        external
        returns (bool);
}
