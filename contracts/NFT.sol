pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./Share.sol";

contract NFT is ERC721Token, Ownable {

    Share tokenShares;

    constructor()  ERC721Token("CryptoPuff", "PUFF") public { }

    function mintTo(address _to, string _tokenURI) public onlyOwner {
        uint256 newTokenId = _getNextTokenId();
        _mint(_to, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
    }

    function createShare(string _shareName, string _shareSymbol, uint8 _shareDecimals) public onlyOwner {
        Share iShare = new Share(_shareName, _shareSymbol, _shareDecimals);
        tokenShares = iShare;
    }

    function mintShares(uint _amount) public onlyOwner {
        tokenShares.mint(msg.sender, _amount);
    }

    function _getNextTokenId() private view returns (uint256) {
        return totalSupply().add(1); 
    }
}
