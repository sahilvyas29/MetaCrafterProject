// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "./MyToken.sol";
import "hardhat/console.sol";

contract CrowdFund
{
     address public owner; 
     uint public fundRaised;
     uint public fundTarget;
     uint public fundTargetTime;

     struct fundProvider{
         uint amount;
         uint timestamp;
         bool funded;
     }

      mapping(address=>fundProvider)  public  shareHolder;

      modifier _onylOwner()
      {
       require(msg.sender == owner);
      _;  
      }

      MyToken token;

     constructor(address _owner,uint _fundTarget,uint _fundTargetTime, string memory name, string memory symbol){
        owner = _owner;
        fundTarget = _fundTarget;
        fundTargetTime = _fundTargetTime;
        token = new MyToken(name,symbol);
     }

     function fund() external payable
     {
        require(msg.value>0,"You cannot fund 0 amount");
        require(block.timestamp<=fundTargetTime,"This fund raise is over!");
        require(!shareHolder[msg.sender].funded,"You can fund only once!");
        require((msg.value+fundRaised <= fundTarget),"You are proving more than required!");
        fundRaised+=msg.value;
        shareHolder[msg.sender] = fundProvider(msg.value,block.timestamp,true);
        token.mint(msg.sender,msg.value);
    }

     function withdrawFund() external 
     {
        require(block.timestamp>fundTargetTime,"You can only withdraw if target is not met before time");
        require(shareHolder[msg.sender].funded,"You did not fund yet!");
        uint amount = shareHolder[msg.sender].amount;
        fundRaised-=amount;
        shareHolder[msg.sender] = fundProvider(0,block.timestamp,false);
        token.burn(msg.sender,amount);
        payable(msg.sender).transfer(amount);
     }
     function collectFund() external _onylOwner 
     {
          require(fundRaised == fundTarget,"Target not met yet");
          require(block.timestamp>fundTargetTime,"You can only collect after raise is over!");
          payable(msg.sender).transfer(fundTarget);
     }

     function MyShareBalance() external view returns(uint)
     {
         return token.balanceOf(msg.sender);
     }
}