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

contract Challenge4_MyCoinV1 {
   
    address[] users;
    mapping(address => uint) private balanceByUser;

    event Transfer(
        address indexed source,
        address indexed target,
        uint amount,
        bool issue);

    modifier haveEnoughBalance(uint amountTransfer) {
        require(balanceByUser[msg.sender] >= amountTransfer, "You do not have enough balance to make the transfer");
        _; 
    }

    constructor(uint balanceInit) {
        balanceByUser[msg.sender] = balanceInit;
        users.push(msg.sender);
    }

    function issue(address target, uint amount) external {
        require(getIssuer() == msg.sender, "It is not the direction with the greatest balance");
        require(balanceByUser[msg.sender] > amount, "You cannot issue an amount equal to or greater than your balance");

        executeMovement(target, amount, true);
    }

    function trasnfer(address target, uint amount) external haveEnoughBalance(amount) {
        executeMovement(target, amount, false);
    }

    function query() external view returns (uint){
        return balanceByUser[msg.sender];
    }

    function executeMovement(address target, uint amount, bool emission) private {
        validateMovement(target, amount, emission ? "issue":"transfer");

        if(!contains(target)) {
            users.push(target);
        } 

        if(!emission) {
            balanceByUser[msg.sender] -= amount;
        }
        balanceByUser[target] += amount;

        emit Transfer(msg.sender, target, amount, emission);
    }

    function validateMovement(address target, uint amount, string memory action) private view {
        require(msg.sender != target, concat("I can't ", action, " myself"));
        require(target != address(0), concat("I can't burn amount ", action, ""));
        require(amount > 0, concat("Amount ", action, " can't be 0"));
    }

    function contains(address addr) private view returns (bool) {     
        for (uint i = 0; i < users.length;) {
            if(users[i] == addr) {
                return true;
            }
            unchecked{ i++; }
        }
       return false;
    }

    function getIssuer() private view returns (address) {
        uint maxBalance;
        address issuer;
        
        for (uint i = 0; i < users.length;) {
            if(balanceByUser[users[i]] > maxBalance) {
                issuer = users[i];
                maxBalance = balanceByUser[users[i]];
            }
            unchecked{ i++; }
        }
       return issuer;
    }

    function concat(string memory a, string memory b, string memory c) private pure returns(string memory) {
       return string(abi.encodePacked(a,b,c));
    }
}