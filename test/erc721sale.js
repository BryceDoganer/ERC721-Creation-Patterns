const ERC721Sale = artifacts.require('ERC721Sale');

contract('ERC721Sale', (accounts) => {

  let sale; 

  const owner = accounts[0];
  const contributor = accounts[1];
  const contributortwo = accounts[2];
  const contributorthree = accounts[3];

  beforeEach(async() => {
    sale = await ERC721Sale.new('Token', 'TKN');
  });

  it('should mint tokens to one addresses', async () => {
    let estimate = await sale.mintOne.estimateGas(contributor, 7);
    console.log('Gas cost to mint one: ', estimate);
    await sale.mintOne(contributor, 7);
    let tokenOwner = await sale.ownerOf(7);
    assert.strictEqual(tokenOwner, contributor, 'Did not mint properly');
  });

  it('should mint multiple tokens', async() => {
    let estimate = await sale.mintMultiple.estimateGas([contributor, contributortwo]);
    console.log('Gas cost to mint two: ', estimate);
    await sale.mintMultiple([contributor, contributortwo]);
    let tokenownerone = await sale.ownerOf(0);
    let tokenownertwo = await sale.ownerOf(1);
    assert.strictEqual(tokenownerone, contributor, 'Did not mint properly to first contributor');
    assert.strictEqual(tokenownertwo, contributortwo, 'Did not mint properly to second contributor');
  })

  it('Should allow for an ERC721, ERC20 representative contract', async() => {
    let estimate = await sale.createERC20Representative.estimateGas('Token', 'TKN', 18, 1000, 50);
    console.log('Gas to produce an ERC20 rep contract: ', estimate); 
    await sale.createERC20Representative('Token', 'TKN', 18, 1000, 50, {gas: 2000000});
    let tokenowner = await sale.ownerOf(0);
    let saleaddress = await sale.address; 
    assert.strictEqual(tokenowner, saleaddress, 'Did not mint token properly');
  })

  it('Should allow a buyer to purchase part of an ERC721 represented by ERC20s', async() => {
    await sale.createERC20Representative('Token', 'TKN', 18, 1000, 50, {gas: 2000000});
    let estimate = await sale.buyPortion.estimateGas(0, {from: contributor, value: 300});
    console.log('Gas to buy ERC20 rep of ERC721: ', estimate);
    await sale.buyPortion(0, {from: contributor, value: 300});
  })
})