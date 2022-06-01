// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

abstract contract Crowdfund is Context, Ownable {
    enum Crowdfund_Method {
        ETH_RAISED,
        MINT_NUMBER,
        DEFAULT
    }
    Crowdfund_Method public crowdfund_method;
    uint256 public goal;
    bool goalMet;
    uint256 public startDate;
    uint256 public endDate;

    constructor() {
        crowdfund_method = Crowdfund_Method.DEFAULT;
        goal = 0;
        goalMet = false;
        startDate = 1;
        endDate = 1;
    }

    function _setCrowdfundMethod(uint256 method) internal onlyOwner {
        if (method == 0) {
            crowdfund_method = Crowdfund_Method.ETH_RAISED;
        } else if (method == 1) {
            crowdfund_method = Crowdfund_Method.MINT_NUMBER;
        } else {
            crowdfund_method = Crowdfund_Method.DEFAULT;
        }
    }

    function readCrowdfundMethod() public view returns (bytes32) {
        bytes32 method;
        if (crowdfund_method == Crowdfund_Method.DEFAULT) {
            method = "DEFAULT";
        } else if (crowdfund_method == Crowdfund_Method.ETH_RAISED) {
            method = "ETH_RAISED";
        } else {
            method = "MINT_NUMBER";
        }
        return method;
    }

    function _setCrowdfundGoal(uint256 _goal) internal onlyOwner {
        require(
            crowdfund_method != Crowdfund_Method.DEFAULT,
            "Crowdfund Method is not set"
        );
        goal = _goal;
    }

    function readCrowdfundGoal() external returns (uint256) {
        return goal;
    }

    function _verifyCrowdfundGoal(uint256 supply) internal returns (bool) {
        //TODO: Add Safe Withdraw Logic. If the owner withdraws funds from the contract,
        //the goal trigger will not be met, therefore redeems will be closed on the next mint

        if (crowdfund_method == Crowdfund_Method.ETH_RAISED) {
            return (address(this).balance >= goal ? true : false);
        } else if (crowdfund_method == Crowdfund_Method.MINT_NUMBER) {
            return (supply >= goal ? true : false);
        } else {
            return false;
        }
    }

    function _setSalePeriod(uint256 _startDate, uint256 _endDate)
        internal
        onlyOwner
    {
        startDate = _startDate;
        endDate = _endDate;
    }

    function _verifySalePeriod(uint256 txTime)
        internal
        onlyOwner
        returns (bool)
    {
        if (startDate == 0 && endDate == 0) {
            return true;
        } else if (txTime >= startDate && txTime < endDate) {
            return true;
        } else {
            return false;
        }
    }
}
