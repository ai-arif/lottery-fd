//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.19;

// --Manager -> players -> taka die ticket -> unique identity -> box er vetore ticket -> winner - Prize 

contract Lottery{
    address public manager;
    address[] public players;
    uint public balance;

    //Constructor
    constructor(){
        manager = msg.sender;
    }

    function enterToGame() public payable {
        require(msg.value > 0.1 ether, "You are not allowed to enter, please pay min 0.1 or more than of it");
        players.push(msg.sender);
        balance += msg.value;
    }

    function randomNumber() private view returns(uint){
        //unique things -> block number, timestamp, players 
       return uint(keccak256(abi.encodePacked(blockhash(block.number - 1), block.timestamp, players)));
    }
 
    function winner() public restrictedArea{
        require(players.length > 0);
        uint playerIndex = randomNumber() % players.length;
        address payable finalWinner = payable (players[playerIndex]);
        uint winningBalance = balance;
        balance = 0;
        players = new address[](0);
        finalWinner.transfer(winningBalance);

    }

    modifier restrictedArea(){
        require(msg.sender == manager, "Only manager can pick winner");
        _;
    }

    function getPlayers() public view returns(address[] memory){
        return players;
    }

}


