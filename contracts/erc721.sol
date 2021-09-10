
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Name: Zaeem Tariq
// Assignment 4
// Roll.No: PIAIC79218

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PIAIC_ERC721 is Ownable, ERC721 {
    
    uint public sale_start_date=0;
    uint public sale_end_date=0;
    uint public sale_Price;
    string public baseURI = "https://floydnft.com/token/&quot";
    uint public total_Supply;
    uint private LAST_TOKEN_ID = 100;
    uint last_Public_Token_Index = 0;

    uint _salePrice = 100;
    string _tokenName = "NFT Assignment"; 
    string _tokenSymbol = "PIAIC_2021";
    
    constructor() ERC721(_tokenName,_tokenSymbol){
        sale_Price = _salePrice;
    }
    
    
    //set sale sale_time
    function setSaleTime() public onlyOwner{
        sale_start_date= block.timestamp;
        sale_end_date = block.timestamp + 30;
    }
    
    //check sale_time
    modifier saleTime() {
        if(sale_end_date > (block.timestamp))
        {
            _;
        }
        
        else{
            sale_start_date = 0;
            sale_end_date = 0;
            require(sale_start_date != 0,"Sale didn't started yet! ");
        }
    
    }
    
    
    
    //Change nft _salePrice
    function changeNFTPrice(uint256 newPrice) public onlyOwner{
        sale_Price= newPrice;
    }
    
    
    function _baseURI() internal view override returns(string memory){
        return baseURI;
    }
    
    //setting modifier for cheking the token limit
    modifier  chekTokenLimit() {
        require(last_Public_Token_Index<=LAST_TOKEN_ID,"Sorry, Token Limit Exceeds ");
        _;
    }
    
    //Setiing Base Uri Only Owner Can Set 
    function setBaseUri(string memory newUri) external onlyOwner {
        baseURI = newUri;
    }
    
    function _mintAndIncrementSupply(address to, uint tokenId) internal{
        _mint(to,tokenId);
        total_Supply++;
    }
    
    
    //Customer can  buy NFT through this function
    function buyNft(uint quantity) external payable chekTokenLimit saleTime{
        uint lastTokenId = last_Public_Token_Index;
        require(msg.value == sale_Price * quantity,"Invalid amount!");
        
        for(uint i = 0; i < quantity; i++){
            lastTokenId++;
            _mintAndIncrementSupply(msg.sender,lastTokenId);
        }
        last_Public_Token_Index = lastTokenId;
    }
}