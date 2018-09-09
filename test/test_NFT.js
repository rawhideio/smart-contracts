const NFT = artifacts.require('NFT');
const Share = artifacts.require('Share');
const Dai = artifacts.require('Dai');
const should = require('should');

contract('CryptoCattle', function (accounts) {
  
  let nft;
  let dai;
  let owner = accounts[0];
  let account1 = accounts[1];
  let account2 = accounts[2];
  let account3 = accounts[3];
  var tokenIds;

  describe('deploy cattle NFT and shares', async function () {

    beforeEach(async () => {
    dai = await Dai.new({from: account1, gas: 2000000});
    nft = await NFT.new(dai.address, {from: owner});
  });

    it('NFT should be deployed', async () => {
      assert.ok(nft, "NFT is not deployed");
    });

    it('deploying account should be owner', async () => {
        let contractOwner = await nft.owner();
        assert.equal(contractOwner, owner, "deploying account is not owner")
    });

    it('mint new CryptoCattle with shares', async () => {
        await nft.mintToken("tokendata.com", "Ginger Cow", "CCCGC", {from: owner});
        
        let shareAddress = await nft.getShareAddress.call(1);
        let shareInstance = Share.at(shareAddress);

        assert.ok(shareAddress, "ERC20 shares aren't deployed");

        let ownerBalance = await shareInstance.balanceOf.call(owner);
        assert.equal(10000, ownerBalance, "owner doesn't hold the issued tokens");
    });
  });

    describe('perform cattle payments', function () {

        let shareToken;

        beforeEach(async() => {
            
            dai = await Dai.new({from: account1, gas: 2000000});
            nft = await NFT.new(dai.address, {from: owner});

            await nft.mintToken("tokendata.com", "Ginger Cow", "CCCGC", {from: owner});
            let shareAddress = await nft.getShareAddress.call(1);
            shareToken = Share.at(shareAddress);
        });

        it('issue share tokens and process payments', async () => {
            await shareToken.transfer(account2, 400, {from: owner});
            await shareToken.transfer(account3, 600, {from: owner});
            
            let balance2 = await shareToken.balanceOf.call(account2);
            let balance3 = await shareToken.balanceOf.call(account3);
            assert.equal(400, balance2, 'acccount2 balance is incorrect');
            assert.equal(600, balance3, 'acccount3 balance is incorrect');

            nft.issuePayment(1, 2000, {from: account1});
           
        });
    });
 });
