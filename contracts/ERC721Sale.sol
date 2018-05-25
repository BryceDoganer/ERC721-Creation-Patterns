pragma solidity 0.4.23;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "./NewERC20.sol"; 

contract ERC721Sale is ERC721Token, Ownable {

    //In open-zeppelin, index has to be given in minting function
    //TO-DO - Better way to handle automatic ids of 721s? 
    uint256 public id = 0; 

    struct AssetInfo {
        address erc20token; 
        uint256 price; //total price in wei
        //Store prices, other info?, store other contract?
    }

    mapping(uint256 => AssetInfo) public tokenInfo; 

    constructor(string _name, string _symbol) ERC721Token(_name, _symbol) public {
        //Initial parameters - TBD
    }

    //Different options for minting for a sale - broad view examples

    //Mint one to check the gas
    function mintOne(address _to, uint256 _index) public {
        super._mint(_to, _index);
    }

    //If just minting ERC721s for contributors, could also have array of id - messy
    function mintMultiple(address[] _receivers) public {
        for (uint256 i = 0 ; i < _receivers.length; i++){
            super._mint(_receivers[i], id);
            id++; 
        }
    }

    /* One ERC721 representing a larger asset that people want to own a portion of, but won't fully control. */
    function createERC20Representative(
        string _name, 
        string _symbol, 
        uint8 _decimals, 
        uint256 _supply, 
        uint256 _price) public  {
        NewERC20 token = new NewERC20(_name, _symbol, _decimals, _supply); 
        //Hold the ERC721 in the contract or another address? Would need to add transfer functions here
        super._mint(this, id); 
        tokenInfo[id].erc20token = token; 
        tokenInfo[id].price = _price; 
        id++; 
    }


    //Function to buy a portion of ERC721 asset
    function buyPortion(uint256 _id) public payable {
        //Grab ERC20 contract from metadata of ERC721
        address token = tokenInfo[_id].erc20token; 
        uint256 amount = msg.value;
        uint256 price = tokenInfo[_id].price; 
        ERC20(token).transfer(msg.sender, amount.div(price));
    }

}