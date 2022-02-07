// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract NFT is ERC721URIStorage, ReentrancyGuard{
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

//add option to alter comissions
//add option to alter item properties
//add 'category' to item data thing and a sorting mechanism to website
//code auction and collection features
//TEST DOING TRANSACTION FROM ANOTHER NETWORK, goreli or something
//using firebase for user data management OR fixed file
//fix the approval thing to enable nft sales




    address payable owner;
    uint256 networkComission = 1;
    uint256 original_owner_comission = 2;
    address constant networkAdd = 0x2E6102cA1e020bfD044A3CB54540F84Dcb4eAF02;

    constructor() ERC721("Unnamed Token", "UNTK") {
        owner = payable(msg.sender);
    }
    struct MarketItem {
        uint itemId;
        uint256 tokenId;
        address payable seller;
        address payable owner;
        uint256 price;
        bool sold;
        address payable original_owner;
        }
    mapping(uint256 => MarketItem) private idToMarketItem;

    event MarketItemCreated (
        uint indexed itemId,
        uint256 indexed tokenId,
        address seller,
        address owner,
        uint price,
        bool sold,
        address original_owner
    );
    function burn(uint256 tokenID) public {
        require(msg.sender == idToMarketItem[tokenID].owner, "you are not the owner");
        _burn(tokenID);
    }


    function createToken(string memory _tokenURI,
    uint256 price) public payable nonReentrant {
        _itemIds.increment();
        uint256 newItemId = _itemIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, _tokenURI);

        require(price >= 0 ether, "Sellign price must be greater than 0 eth");
        idToMarketItem[newItemId] =  MarketItem(
            newItemId,
            newItemId,
            payable(msg.sender),
            payable(msg.sender),
            (price),
            false,
            payable(msg.sender));
            transferFrom(msg.sender, msg.sender, newItemId);

            emit MarketItemCreated(
                newItemId,
                newItemId,
                msg.sender,
                msg.sender,
                (price),
                false,
                msg.sender);
    }


    function createMarketSale(
    uint256 itemId
    ) public payable nonReentrant {
        uint price = idToMarketItem[itemId].price;
        address payable original_owner = idToMarketItem[itemId].original_owner;
        address payable current_owner = idToMarketItem[itemId].owner;
        require(idToMarketItem[itemId].sold == false, "Item not for sale");
        require(msg.value >= price, "Please submit equal to or greater than asking price in order to complete the purchase");
//        approve(msg.sender, itemId);
//        didn't work
        uint256 tmp = msg.value;
        uint256 price_percent = msg.value/100;
        uint256 network_comission = price_percent*networkComission;
        uint256 _original_owner_comission = price_percent*original_owner_comission;
        tmp = tmp - network_comission;
        tmp = tmp - _original_owner_comission;
        idToMarketItem[itemId].seller.transfer(tmp);
        transferFrom(current_owner, msg.sender, itemId);
        idToMarketItem[itemId].owner = payable(msg.sender);
        idToMarketItem[itemId].sold = true;
        _itemsSold.increment();
        payable(networkAdd).transfer(network_comission);
        payable(original_owner).transfer(_original_owner_comission);
  }

  /* Returns all unsold market items */
  function fetchMarketItems() public view returns (MarketItem[] memory) {
    uint itemCount = _itemIds.current();
    uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
    uint currentIndex = 0;

    MarketItem[] memory items = new MarketItem[](unsoldItemCount);
    for (uint i = 0; i < itemCount; i++) {
      if (idToMarketItem[i + 1].sold == false) {
        uint currentId = i + 1;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }

  /* Returns only items that a user has purchased */
  function fetchMyNFTs() public view returns (MarketItem[] memory) {
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMarketItem[i + 1].owner == msg.sender) {
        itemCount += 1;
      }
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMarketItem[i + 1].owner == msg.sender) {
        uint currentId = i + 1;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }

  /* Returns only items a user has created */
  function fetchItemsCreated() public view returns (MarketItem[] memory) {
    uint totalItemCount = _itemIds.current();
    uint itemCount = 0;
    uint currentIndex = 0;

    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMarketItem[i + 1].seller == msg.sender) {
        itemCount += 1;
      }
    }

    MarketItem[] memory items = new MarketItem[](itemCount);
    for (uint i = 0; i < totalItemCount; i++) {
      if (idToMarketItem[i + 1].seller == msg.sender) {
        uint currentId = i + 1;
        MarketItem storage currentItem = idToMarketItem[currentId];
        items[currentIndex] = currentItem;
        currentIndex += 1;
      }
    }
    return items;
  }
}