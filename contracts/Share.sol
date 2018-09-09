pragma solidity ^0.4.22;

import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
import "zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
import './Dai.sol';

/**
 * The InvestorToken contract creates new ERC20 that property investors will hold
 */
contract Share is MintableToken, DetailedERC20 {
    
    Dai public dai;
    mapping(address => uint) stakeIndex;
    Stake[] public stakes;

    struct Stake {
        address owner;
        uint stakeAmount;
        uint paymentBalance;
    }
    
    constructor(
        address _daiAddress,
        string _name,
        string _symbol,
        uint8 _decimals)
        DetailedERC20(
            _name,
            _symbol,
            _decimals) public {
        dai = Dai(_daiAddress);
        stakes.push(Stake(address(0), 0 ,0));
    }

    function claimBalance()
        public returns (bool) {
        require(stakeIndex[msg.sender] != 0);
        require(stakes[stakeIndex[msg.sender]].paymentBalance > 0);
        uint amount = stakes[stakeIndex[msg.sender]].paymentBalance;
        stakes[stakeIndex[msg.sender]].paymentBalance = 0;
        require(dai.transferFrom(address(this), msg.sender, amount));
        return true;
    }

    function stakeShares (uint _amount)
        public returns (bool) {
        require(this.transferFrom(msg.sender, address(this), _amount));
        if(stakeIndex[msg.sender] == 0){
            stakes.push(Stake(msg.sender, _amount, 0));
            stakeIndex[msg.sender] = stakes.length;
        }
        else {
            stakes[stakeIndex[msg.sender]].stakeAmount += _amount;
        }
        return true;
    }

    function reclaimShares(uint _amount)
        public returns (bool) {
        require(stakeIndex[msg.sender] != 0);
        require(stakes[stakeIndex[msg.sender]].stakeAmount > _amount);
        stakes[stakeIndex[msg.sender]].stakeAmount -= _amount;
        require(this.transferFrom(address(this), msg.sender, _amount));
        return true;
    }

    function processPayment(uint _amount)
        public returns (bool) {
        require(dai.transferFrom(msg.sender, address(this), _amount));
        for(uint i = 1; i < stakes.length; i++)
        {
            uint supply = this.totalSupply();
            if(stakes[i].stakeAmount == 0) continue;
            else {
                stakes[i].paymentBalance += supply.div(stakes[i].stakeAmount).mul(_amount);
            }
        }
        return true;
    }
}

