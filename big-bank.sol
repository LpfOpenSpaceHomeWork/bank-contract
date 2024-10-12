// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Bank } from "bank.sol";

error LowerThanMinimumDeposit(uint value);

contract BigBank is Bank {

    modifier minimumValue(uint value) {
        if (msg.value <= value) {
            revert LowerThanMinimumDeposit(value);
        }
        _;
    }

    function transferAdmin(address payable newAdmin) public onlyOwner {
        admin = newAdmin;
    }

    function depositFromMsgInfo() internal minimumValue(0.0001 ether) override {
        super.depositFromMsgInfo();
    }
}