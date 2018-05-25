pragma solidity 0.4.23; 

import "openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";


contract NewERC20 is DetailedERC20, StandardToken {
    constructor(
        string _name, 
        string _symbol, 
        uint8 _decimals, 
        uint256 _supply) DetailedERC20(_name, _symbol, _decimals) public {
        totalSupply_ = _supply;
        balances[msg.sender] = _supply;
    }
}