// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC6682 {
    /// @dev The address of the token used to pay flash loan fees.
    function flashFeeToken() external view returns (address);

    /// @dev Whether or not the NFT is available for a flash loan.
    /// @param token The address of the NFT contract.
    /// @param tokenId The ID of the NFT.
    function availableForFlashLoan(address token, uint256 tokenId) external view returns (bool);
}
