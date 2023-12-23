// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

//  erc20 interface
interface IERC20 {
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract pool {

  mapping(address=>mapping(address=>uint)) balance;
  mapping(address=>bool) contractList;
  
  constructor(address[] memory _contractList){
     for (uint256 i = 0; i < _contractList.length; i++) {
            contractList[_contractList[i]]=true;
     }
  }

  function deposit(IERC20 erc20,uint amount) public {
    balance[address(erc20)][tx.origin] += amount;
    erc20.transferFrom(msg.sender, address(this), amount);
  }
  function withdraw(IERC20 erc20,uint amount,address to) public {
    balance[address(erc20)][tx.origin] -= amount;
    erc20.transferFrom(address(this), to, amount);
  }
  function approve(IERC20 erc20,uint amount) external {
    require(contractList[msg.sender]==true);
    erc20.approve(msg.sender, amount);
  }
  function getBalance(IERC20 erc20, address owner) public view returns(uint){
     return balance[address(erc20)][owner];
  }
}