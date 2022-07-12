// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract Graffiti {

    struct Message {
        address author;
        string message;
        uint date;
    }

    Message lastMessage;

    function saveMesage(string memory messageNew) external {
        lastMessage.message = messageNew;
        lastMessage.author = msg.sender;
        lastMessage.date = block.timestamp;
    }

    function viewMessage() external view returns(Message memory) {
        return lastMessage;
    }
}