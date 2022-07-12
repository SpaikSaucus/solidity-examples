// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

/*
MyCoin:
- Store user balances
- Transfers between users (balances are modified)
- Balance check (to be able to make transfers -> do it with a modifier)
- Issue an event on each transfer
- Issuance of currency only for the user who has the most balance, and can issue less than his own balance
- The constructor receives a parameter that indicates the initial balance of the sender account
- The issuer cannot issue itself
*/

struct User {
    address addr;
    uint balance;
}

struct itmap {
    mapping(uint => User) data;
    mapping(address => uint) key;
    uint size;
}

library IterableMapping {
    function insert(itmap storage self, address key, User memory value) internal returns (bool replaced) {
        uint keyIndex = self.key[key];
        if (keyIndex > 0){
            replaced = true;
        } else {
            self.size++;
            self.key[key] = self.size;
        }
        self.data[self.size] = value;
    }

    function contains(itmap storage self, address key) internal view returns (bool) {
        return self.key[key] > 0;
    }

    function get(itmap storage self, address key) internal view returns (User storage value) {
        value = self.data[self.key[key]];
    }

    function iterateValid(itmap storage self, uint keyIndex) internal view returns (bool) {
        return keyIndex <= self.size;
    }

    function iterateGet(itmap storage self, uint keyIndex) internal view returns (User storage value) {
        value = self.data[keyIndex];
    }
}


contract Challenge4_MyCoinV2 {

    using IterableMapping for itmap;

    itmap users;

    event Transfer(
        address indexed source,
        address indexed target,
        uint amount,
        bool issue);

    modifier haveEnoughBalance(uint amountTransfer) {
        require(users.get(msg.sender).balance >= amountTransfer, "You do not have enough balance to make the transfer");
        _; 
    }

    constructor(uint balanceInit) {
        User memory newUser = User(msg.sender, balanceInit);
        users.insert(msg.sender, newUser);
    }

    function issue(address target, uint amount) external {
        require(getIssuer() == msg.sender, "It is not the direction with the greatest balance");
        require(users.get(msg.sender).balance > amount, "You cannot issue an amount equal to or greater than your balance");
        
        executeMovement(target, amount, true);
    }

    function transfer(address target, uint amount) external haveEnoughBalance(amount) {
        executeMovement(target, amount, false);
    }

    function query() external view returns (uint){
        return users.get(msg.sender).balance;
    }

    function executeMovement(address target, uint amount, bool emission) private {
        validateMovement(target, amount, emission ? "issue":"transfer");

        if(!users.contains(target)) {
            User memory newUser = User(target, amount);
            users.insert(target, newUser);
        } else {
            User storage userTarget = users.get(target);
            userTarget.balance += amount;
        }

        if(!emission) {
            User storage userSource = users.get(msg.sender);
            userSource.balance -= amount;
        }

        emit Transfer(msg.sender, target, amount, emission);
    }

    function validateMovement(address target, uint amount, string memory action) private view {
        require(msg.sender != target, concat("I can't ", action, " myself"));
        require(target != address(0), concat("I can't burn amount ", action, ""));
        require(amount > 0, concat("Amount ", action, " can't be 0"));
    }

    function getIssuer() private view returns (address) {
        uint maxBalance;
        address issuer;
        
        for (uint i = 1; users.iterateValid(i);) {
            (User memory value) = users.iterateGet(i);

            if(value.balance > maxBalance) {
                issuer = value.addr;
                maxBalance = value.balance;
            }

            unchecked{ i++; }
        }

       return issuer;
    }

    function concat(string memory a, string memory b, string memory c) private pure returns(string memory) {
       return string(abi.encodePacked(a,b,c));
    }
}