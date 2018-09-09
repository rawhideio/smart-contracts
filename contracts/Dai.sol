pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/token/ERC20/MintableToken.sol";
contract Dai is MintableToken {
    string public constant name = "Dai Token";
    string public constant symbol = "DAI";
    uint8 public constant decimals = 18;

    function mintTo(address to, uint amount) public 
    {
        mint(to, amount);
    }

}
