// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { TestToken } from "./test-token.sol";

contract TokenBank {

    TestToken public token;
    mapping(address => uint) public deposits;

    constructor(TestToken _token) {
        token = _token;
    }

    // ensure you have approve the bank to transfer your token;
    function deposit(uint256 amount) public {
        require(amount <= token.allowance(msg.sender, address(this)), "No enough token approved to deposit");
        token.transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] += amount;
    }

    function withdraw(uint256 amount) public {
        require(deposits[msg.sender] >= amount, "No enough token balance to withdraw");
        token.transfer(msg.sender, amount);
        deposits[msg.sender] -= amount;
    }
}