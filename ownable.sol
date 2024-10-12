// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Bank } from "./big-bank.sol";

contract Ownable {
    address payable private immutable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function withdrawFromBank(Bank bank) public {
        bank.withdraw();
    }

    function withdrawToOwner() public {
        uint balance = address(this).balance;
        require(balance > 0, "No balance remains to withdraw");
        (bool success,) = owner.call{value: balance}("");
        require(success, "Failed to withdraw to owner");
    }

    receive() external payable {
        // do nothing
    }

    fallback() external payable {
        // do nothing
    }
}