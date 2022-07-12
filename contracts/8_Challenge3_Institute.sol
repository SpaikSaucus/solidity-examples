// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

/*
-Generate a contract that stores notes per student sent by teacher.
    -A method that receives note for a student and subject associated with note. Plus it emits an added note event.
    -A method that calculates the average of notes from an indicated student.
*/

contract Challenge3_Institute {
   
    address owner;
    mapping(address => uint[]) private notesByStudent;

    event NoteAdd(
        address indexed student, 
        uint note, 
        string subject);

    modifier isOwner() {
        require(msg.sender == owner, "not the owner");
        _; 
    }

    constructor() {
        owner = msg.sender;
    }

    function agregarNote(string memory subject, address student, uint note) external isOwner {
        require(note <= 10, "Note can't be higher than 10");
        require(student != address(0), "the student does not exist");
        require(student != owner, "the student can't be owner");
        
        notesByStudent[student].push(note);
        emit NoteAdd(student, note, subject);
    }

    function calcularPromedio(address student) external view returns(uint) {
        require(notesByStudent[student].length > 0, "the student does not have notes loaded or does not exist");
        
        uint sum;
        for(uint i = 0; i < notesByStudent[student].length; i++) {
            sum += notesByStudent[student][i];
        }

        return (sum/notesByStudent[student].length);
    }
}