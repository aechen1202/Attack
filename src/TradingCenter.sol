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
interface IPOOL {
  function deposit(IERC20 erc20,uint amount) external;
  function withdraw(IERC20 erc20,uint amount,address to) external;
  function approve(IERC20 erc20,uint amount) external;
}
interface IReceiver {
    function receiveTokens(address tokenAddress, uint256 amount) external;
}

contract TradingCenter {

  bool public initialized;

  IERC20 public usdt;
  IERC20 public usdc;
  address pool;
  uint256 private _guardCounter;

  constructor(IERC20 _usdt, IERC20 _usdc, address _pool){
    usdt = _usdt;
    usdc = _usdc;
    pool = _pool;
  }

  modifier nonReentrant() {
    _guardCounter += 1;
    uint256 localCounter = _guardCounter;
    _;
    require(localCounter == _guardCounter);
  }

  function dispose(IERC20 erc20,uint amount) public nonReentrant {
    require(address(erc20)== address(usdc) || address(erc20)== address(usdt));
    erc20.transferFrom(msg.sender, address(this), amount);
    IPOOL(pool).deposit(erc20, amount);
  }

  function withdraw(IERC20 erc20,uint amount) public nonReentrant{
    require(address(erc20)== address(usdc) || address(erc20)== address(usdt));
    IPOOL(pool).withdraw(erc20, amount, msg.sender);
  }

  function flashLoan(IERC20 erc20, uint256 borrowAmount) external nonReentrant {
        require(address(erc20)== address(usdc) || address(erc20)== address(usdt));
        if (borrowAmount == 0) revert("MustBorrowOneTokenMinimum");

        uint256 balanceBefore = erc20.balanceOf(pool);
        if (balanceBefore < borrowAmount) revert("NotEnoughTokensInPool");
        IPOOL(pool).approve(erc20, borrowAmount);
        erc20.transferFrom(pool, msg.sender, borrowAmount);

        IReceiver(msg.sender).receiveTokens(address(erc20), borrowAmount);

        uint256 balanceAfter = erc20.balanceOf(pool);
        if (balanceAfter < balanceBefore) revert("FlashLoanHasNotBeenPaidBack");
    }
    
}
