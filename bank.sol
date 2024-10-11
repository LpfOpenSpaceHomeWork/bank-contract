// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Whale {
    address addr;
    uint depositBalance;
}

contract Bank {
    mapping(address => uint) public deposits;
    address[3] public top3Whales;
    address payable private immutable admin;

    constructor() {
        admin = payable(msg.sender);
    }

    function getTop3Whales() public view returns(Whale[3] memory whales) {
        for(uint8 i = 0; i < 3; i++) {
            whales[i] = Whale({
                addr: top3Whales[i],
                depositBalance: deposits[top3Whales[i]]
            });
        }
    }

    function withdraw() public {
        require(msg.sender == admin, "Only the administrator can withdraw all the deposits");
        uint depositsBalance = address(this).balance;
        require(depositsBalance > 0, "No balance remains to withdraw");
        (bool success,) = admin.call{value: depositsBalance}("");
        require(success, "Failed to withdraw all the deposits");
    }

    function deposit(address account, uint amount) private {
        deposits[account] += amount;
        uint currentAccountDeposit = deposits[account];
        address[3] memory localTop3Whales = top3Whales;
        if (currentAccountDeposit > deposits[localTop3Whales[0]]) {
            localTop3Whales[2] = localTop3Whales[1];
            localTop3Whales[1] = localTop3Whales[0];
            localTop3Whales[0] = account;
        } else if (currentAccountDeposit > deposits[localTop3Whales[1]] && currentAccountDeposit < deposits[localTop3Whales[0]]) {
            localTop3Whales[2] = localTop3Whales[1];
            localTop3Whales[1] = account;
        } else if (currentAccountDeposit > deposits[localTop3Whales[2]] && currentAccountDeposit < deposits[localTop3Whales[1]]) {
            localTop3Whales[2] = account;
        }
        top3Whales = localTop3Whales;
    }

    receive() external payable {
        deposit(msg.sender, msg.value);
    }

    fallback() external payable {
        deposit(msg.sender, msg.value);
    }
}