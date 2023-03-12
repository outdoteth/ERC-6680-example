// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import "../src/ExampleFlashBorrower.sol";
import "../src/ExampleFlashLender.sol";
import "./ShibaInu.sol";
import "./Milady.sol";

contract FlashLoanTest is Test {
    uint256 public feePerNFT = 0.01e18;

    ShibaInu shibaInu = new ShibaInu();
    Milady milady = new Milady();
    ExampleFlashLender public lender = new ExampleFlashLender(feePerNFT, address(shibaInu));
    ExampleFlashBorrower public borrower = new ExampleFlashBorrower(lender);

    function setUp() public {
        deal(address(shibaInu), address(borrower), 100e18);
    }

    function test_ExecutesFlashLoan() public {
        // arrange
        uint256 tokenId = 1;
        milady.mint(address(lender), tokenId);

        // act
        borrower.initiateFlashLoan(address(milady), tokenId, "");

        // assert
        assertEq(milady.ownerOf(tokenId), address(lender), "Should have returned NFT to lender");
        assertEq(shibaInu.balanceOf(address(borrower)), 100e18 - feePerNFT, "Should have taken fee from borrower");
        assertEq(shibaInu.balanceOf(address(lender)), feePerNFT, "Should have sent fee to lender");
    }
}
