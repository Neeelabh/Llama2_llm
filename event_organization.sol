// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;


contract EventContract{
    struct Event{
    address organizer;
    string name;
    uint date;
    uint price;
    uint ticketCount;
    uint ticketRemain;
}
 
 mapping(uint=>Event) public events; 
 mapping (address=>mapping(uint=>uint))public tickets; 
 uint public nextId;

function createEvent(string memory name, uint date, uint price, uint ticketCount) external{
        require (date>block.timestamp,"You can organise event for future date");
        require (ticketCount>0," You can organise event only if you have more than 10 tickets");
       events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
        nextId++;
    }
function buyTicket(uint id, uint quantity)external payable{
    require(events[id].date!=0,"Event does not exist");
    require(events[id].date>block.timestamp,"Event is expired");
    Event storage _event = events [id];
    require(msg.value==(_event.price*quantity),"Ether is not enough");
    require(_event.ticketRemain>=quantity,"Ether is not ticket");
    _event.ticketRemain-=quantity;
    tickets[msg.sender][id]+=quantity;
}
function transferTicket(uint id,uint quantity,address to)external{
require(events[id].date!=0,"Event Does not Exist");
require(block.timestamp<events[id].date,"Event is expired");
require(tickets[msg.sender][id]>=quantity,"You do not have enugh ticket");
tickets[msg.sender][id]-=quantity;
tickets[to][id]+=quantity;

}
 }