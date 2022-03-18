// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.4.22 <0.9.0;
contract Child is Ownable, IERC721Receiver{
    address mintAddress;
    address reciever; 
    uint mintCost;
    uint mintAmount;  // num of mint for each address
    uint256[] tokenIds;
    IERC721 public parentNFT;
    constructor(address _mintAddress,uint _mintAmount, uint _mintCost, address _reciever){
       mintAddress = _mintAddress;
       reciever = _reciever;
       mintAmount = _mintAmount;
       parentNFT = IERC721(_mintAddress); 
       mintCost = _mintCost;
    }

    fallback() payable external {}

    event nftIdAdded(uint id);

      function onERC721Received(
        address operator, 
        address from, 
        uint256 tokenId, 
        bytes calldata data)  public virtual override returns (bytes4) {   
        return this.onERC721Received.selector;
        tokenIds.push(tokenId);
        emit nftIdAdded(tokenId);
    } 

    function getTokens() external view returns(uint256[] memory _tokens){
       _tokens = tokenIds;
     }  

event BuyMint(bool status, bytes result);
    
    function buyMint() 
    external
    payable onlyOwner
{
    uint totalCost = mintCost * mintAmount;
    //for(uint i=0;i<mintAmount; i++){
    (bool success, bytes memory returnData) = mintAddress.call{value:totalCost, gas: 3000000}(abi.encodeWithSignature("mint(uint256)", mintAmount));
    // (status, result) = mintAddress.delegatecall(abi.encodePacked(bytes4(keccak256(abi.encodePacked("mint(uint256)"))), mintAmount));
   // require(success);
    emit BuyMint(success, returnData);
    
    parentNFT.setApprovalForAll(owner(), true);
}

    function transferToDad(uint _tokenId) external onlyOwner {
             parentNFT.transferFrom(address(this), reciever, _tokenId);
             parentNFT.setApprovalForAll(reciever, true);
    }

    function destroyContract() external onlyOwner {
        address payable addr = payable(reciever);
        selfdestruct(addr);
  }

}
