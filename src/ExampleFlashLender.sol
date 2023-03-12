// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./interfaces/INFTFlashLender.sol";

contract ExampleFlashLender is INFTFlashLender {
    function availableForFlashLoan(address token, uint256 tokenId) external view returns (bool) {
        return true;
    }

    function flashFee(address token, uint256 tokenId, address feeToken) external view returns (uint256) {
        return 0;
    }

    function flashLoan(address receiver, address token, uint256 tokenId, bytes calldata data) external returns (bool) {
        return true;
    }
}
