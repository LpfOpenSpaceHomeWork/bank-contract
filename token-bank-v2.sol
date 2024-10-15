// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { TokenBank } from "./token-bank.sol";
import { TestToken } from "./test-token.sol";

contract TokenBankV2 is TokenBank {

    constructor(TestToken _token) TokenBank(_token) {
    }

    function tokensReceived(address from, uint256 amount) external {
        require(msg.sender == address(token), "Only the TestToken Contract can call the hook");
        deposits[from] += amount;
    }
}