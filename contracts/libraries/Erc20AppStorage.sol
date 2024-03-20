// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;

library   Erc20AppStorage{

    struct Erc20Apps{
    string  name;
    string symbol;
    uint  decimal;
    uint  totalSupply;
    mapping(address => uint ) balanceOf;
    mapping(address => mapping(address => uint))  allowance;
    }

      struct Erc20Reward{
    string  name;
    string symbol;
    uint  decimal;
    uint  totalSupply;
    mapping(address => uint ) balanceOf;
    mapping(address => mapping(address => uint))  allowance;
    }
    
}