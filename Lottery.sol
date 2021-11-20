pragma solidity ^0.8.9;

contract Lottery{

// -------- Attribute Section --------

    address public manager;
    address payable[] public players;
    
// -------- Public Section --------

    constructor(){
        manager = msg.sender;
    }
    
    function enterLottery() public payable{
        require(msg.value > .01 ether);
        
        players.push(payable(msg.sender));
    }
    
    function getPlayers() public view returns(address payable[] memory){
        return players;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }
    
// -------- Admin Section --------
    
    function pickWinner() public restricted payable returns(address){

        uint indexWinner = random() % players.length;
        address payable winner = players[indexWinner];
        
        winner.transfer(address(this).balance);
        
        players = new address payable[](0);
        return winner;
    }
    
    function returnEntries() public restricted view{


    }
    

// -------- Core Section --------

    function random() private view returns(uint){
        return uint(keccak256(abi.encode(block.difficulty, block.timestamp, players))); //sha3()
    }
    
    //modifier need to determine security level of a function
    //So, it can be used into function declaration es.pickWinner()
    modifier restricted(){
        require(msg.sender == manager);
        //When modifier is called, 
        //the underscore is replaced by compiler with the code of caller function
        _;
    }

}
