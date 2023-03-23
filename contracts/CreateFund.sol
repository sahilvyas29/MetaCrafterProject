// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import{ CrowdFund } from "./CrowdFund.sol";

 contract CreateFund 
{
    CrowdFund crowdFund;
    event CrowdFundCreated(string,address);
         
    function createYourFund(
        uint _fundTarget, //Amount to be raised
        uint _fundTargetTime,  //Time at which the crowd fund expire
        string memory name,  //Name of ERC20
        string memory symbol  //Symbol of ERC20
        ) external 
         {
          crowdFund = new CrowdFund(msg.sender,_fundTarget,_fundTargetTime,name,symbol);
          emit CrowdFundCreated("Your Crowd Fund address is",address(crowdFund));
         }

    
}