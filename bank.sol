// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error OnlyAdministratorCanOperate();

contract Bank {
    mapping(address => uint) public deposits;
    address[3] public top3Whales;
    address payable internal admin;

    modifier onlyOwner() {
        if (msg.sender != admin) {
            revert OnlyAdministratorCanOperate();
        }
        _;
    }

    constructor() {
        admin = payable(msg.sender);
    }

    function withdraw() public onlyOwner {
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

    function depositFromMsgInfo() internal virtual {
        deposit(msg.sender, msg.value);
    }

    receive() external payable virtual {
        depositFromMsgInfo();
    }

    fallback() external payable virtual {
        depositFromMsgInfo();
    }
}