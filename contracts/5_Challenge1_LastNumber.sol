// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

/*
-Generate a contract that stores the last number received and the cumulative number.
    -A method to store the received number and add it to a total.
    -A method that allows to obtain the last number added and the accumulated total.
*/

contract Challenge1_LastNumber {

    uint lastNumber;
    uint totalNumber;

    function saveNumber(uint newLastNumber) external {
        lastNumber = newLastNumber;
        totalNumber += newLastNumber;
    }

    function getLastAndTotalNumber() external view returns(uint, uint) {
        return (lastNumber, totalNumber);
    }
}
