// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "./IUniswapV2Router02.sol";
import "./IMasterChef.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";


contract MyTokenMarket {
    using SafeERC20 for IERC20;

    IUniswapV2Router02 public uniswap_v2;
    IERC20 public myToken;
    IERC20 public sushi;
    IMasterChef public masterChef;

    uint256 public deposited;

    // This is the constructor function, which is called when the contract is deployed
    constructor(IUniswapV2Router02 _uniswap_v2, IERC20 _myToken, IERC20 _sushi, IMasterChef _masterChef) {
        uniswap_v2 = _uniswap_v2;
        myToken = _myToken;
        sushi = _sushi;
        masterChef = _masterChef;
    }

    function addLiquidity(uint256 amount) public payable returns(uint256 amountToken, uint256 amountETH, uint256 liquidity){
        myToken.safeTransferFrom(msg.sender, address(this), amount);
        myToken.approve(address(uniswap_v2), amount);
        (amountToken, amountETH, liquidity) = uniswap_v2.addLiquidityETH{value: msg.value}(address(myToken), amount, 0, 0, msg.sender, block.timestamp);
    }

    function buyToken() public payable returns(uint[] memory amounts){
        address[] memory path = new address[](2);
        path[0] = uniswap_v2.WETH();
        path[1] = address(myToken);
        console.log("buyToken weth:", path[0]);
        console.log("buyToken myToken:", path[1]);
        amounts = uniswap_v2.swapExactETHForTokens{value: msg.value}(0, path, address(this), block.timestamp);
        
        uint256 myTokenAmount = myToken.balanceOf(address(this));
        console.log("myTokenAmount:", myTokenAmount);
        myToken.approve(address(masterChef), myTokenAmount);
        console.log("approve:", myTokenAmount);
        masterChef.deposit(0, myTokenAmount);
        console.log("deposit:", myTokenAmount);
        deposited+=myTokenAmount;
    }

    function withdraw() public {
        masterChef.withdraw(0, deposited);
        myToken.safeTransfer(msg.sender, deposited);
        sushi.safeTransfer(msg.sender, sushi.balanceOf(address(this)));
        deposited = 0;
    }

    function getHexString() public view returns(string memory result) {
        uint256 data = 61783011194088941509941531252653361985318045060999172143526795717082471884981;
        return Strings.toHexString(data);
    }

    
}