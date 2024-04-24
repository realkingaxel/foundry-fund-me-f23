//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";

import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address user = makeAddr("user");

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(user, 10 ether);
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        console.log(version);
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(user);
        fundMe.fund{value: 10e18}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(user);
        assertEq(amountFunded, 10e18);
    }

    function testAddsFunderToArrayOfFunders() public funded {
        address funder = fundMe.getFunders(0);
        assertEq(funder, user);
    }

    modifier funded() {
        vm.prank(user);
        fundMe.fund{value: 10e18}();
        _;
    }

    function OnlyOwnerCanWithdraw() public {
        vm.prank(user);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithDrawWithSingleFunder() public funded {
        uint256 OwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 OwnerBalanceAfter = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(OwnerBalanceAfter, OwnerBalance + startingFundMeBalance);
    }

    function testWithdrawFromMultiplefunders() public funded {
        uint160 numberOfFunders = 10;
        uint160 startingIndex = 1;

        for (uint160 i = startingIndex; i < numberOfFunders; i = i + 1) {
            hoax(address(i), 10e18);
            fundMe.fund{value: 10e18}();
        }

        uint256 OwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        console.log(address(fundMe).balance);
        console.log(fundMe.getOwner().balance);

        assertEq(address(fundMe).balance, 0);
        assertEq(
            startingFundMeBalance + OwnerBalance,
            address(fundMe.getOwner()).balance
        );
    }
}
