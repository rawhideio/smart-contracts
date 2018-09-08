pragma solidity ^0.4.22;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";

/**
 * The InvestorToken contract creates new ERC20 that property investors will hold
 */
contract Share is MintableToken, DetailedERC20 {
    constructor(
        string _name,
        string _symbol,
        uint8 _decimals)
        DetailedERC20(
            _name,
            _symbol,
            _decimals) public {}
}

