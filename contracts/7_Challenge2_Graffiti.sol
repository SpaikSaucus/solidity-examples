// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

/*
-Generate a contract that stores the last message received and validate 2 min for new message for same sender.
    -A method to store the received message and validate rules.
    -A method that allows to obtain the last message added.
*/

contract Challenge2_Graffiti {

    struct Message {
        address author;
        string message;
        uint date;
    }

    Message lastMessage;

    function saveMessage(string memory messageNew) external {
        if (msg.sender == lastMessage.author) {
            uint diffTime = block.timestamp - lastMessage.date;
            if (diffTime < 2 minutes) {
                revert("You must wait 2 min or wait for someone else to leave a message.");
            }
        } else {
            lastMessage.author = msg.sender;
        }

        lastMessage.message = messageNew;
        lastMessage.date = block.timestamp;
    }

    function viewMessage() external view returns(Message memory) {
        return lastMessage;
    }
}