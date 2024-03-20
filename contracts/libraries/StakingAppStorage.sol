// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

library StakingAppStorage{

     struct StakingStorage{
    mapping(address => uint)  balanceOf;
    mapping(address => uint)  stakeTime;
    mapping(address => uint)  rewards;
    uint256 totalSupply;


     }


}

 
