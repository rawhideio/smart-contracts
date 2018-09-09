pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";
import './Dai.sol';
import "./Share.sol";

contract NFT is ERC721Token, Ownable {

    address public daiContract;
    mapping(uint256 => address) public tokenShares; //tokenID mapped to ERC20 share contracts
    uint8 shareDecimals = 4;
    uint shareSupply = 10000;

    constructor(address dai) ERC721Token("CryptoCattle", "CC") public { daiContract = dai; }


    event TokenMinted(address indexed owner, uint256 tokenId, string tokenURI);
    event SharesIssued(uint256 indexed tokenId, string shareSymbol);

    function mintToken(string _tokenURI, string _shareName, string _shareSymbol) 
        public onlyOwner 
        returns (uint256 newTokenId)
    {
        newTokenId = _getNextTokenId();
        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        //add ERC20 minting at creation - 1,000K shares
        emit TokenMinted(msg.sender, newTokenId, _tokenURI);

        Share newShare = new Share(_shareName, _shareSymbol, shareDecimals);
        newShare.mint(msg.sender, shareSupply);
        tokenShares[newTokenId] = address(newShare);
        emit SharesIssued(newTokenId, _shareSymbol);

        return newTokenId;
    }

    function getShareAddress(uint256 _tokenId)
        public view returns (address shareAddress)
    {
        shareAddress = tokenShares[_tokenId];
        return shareAddress;
    }

    function _getNextTokenId() private view returns (uint256) {
        return totalSupply().add(1); 
    }
}
