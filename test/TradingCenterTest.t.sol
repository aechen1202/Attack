// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "solmate/tokens/ERC20.sol";
import "forge-std/console.sol"; 
import { TradingCenter, IERC20 } from "../src/TradingCenter.sol";
contract FiatToken is ERC20 {
  constructor(string memory name, string memory symbol, uint8 decimals) ERC20(name, symbol, decimals){}
}

contract TradingCenterTest is Test {

  // Owner and users
  address owner = makeAddr("owner");
  address user1 = makeAddr("user1");
  address user2 = makeAddr("user2");

  // Contracts
  TradingCenter tradingCenter;
  IERC20 usdt;
  IERC20 usdc;

  // Initial balances
  uint256 initialBalance = 100000 ether;
  uint256 userInitialBalance = 10000 ether;

  function setUp() public {

  }
}