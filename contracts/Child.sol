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
    uint mintCost = 10000 gwei;
    uint mintAmount;  // num of mint for each address
    IERC721 public parentNFT;
    constructor(address _mintAddress,uint _mintAmount, uint _mintCost, address _reciever){
       mintAddress = _mintAddress;
       reciever = _reciever;
       mintAmount = _mintAmount;
       parentNFT = IERC721(_mintAddress); 
    }

    fallback() payable external {}

      function onERC721Received(
        address operator, 
        address from, 
        uint256 tokenId, 
        bytes calldata data)  public virtual override returns (bytes4) {   
        return this.onERC721Received.selector;
        
    } 

event BuyMint(bool status, bytes result);
    
    function buyMint() 
    external
    payable onlyOwner
{
    bool status;
    bytes memory result;
    //change this line depending on the contract being called
   // (bool success, bytes memory returnData) = mintAddress.call{value:mintCost, gas: 3000000}(abi.encodeWithSignature("mint(uint256)", mintAmount));
    (bool success, bytes memory returnData) = mintAddress.call{value:mintCost, gas: 3000000}(abi.encodeWithSignature("mint()")); 
     
    emit BuyMint(success, returnData);
 
}

    function transferToDad(uint256[] memory _ids) external onlyOwner {
          for(uint i=0;i<_ids.length; i++){
             parentNFT.transferFrom(address(this), reciever, i);
       }
    }

    function destroyContract() external onlyOwner {
        address payable addr = payable(reciever);
        selfdestruct(addr);
  }

}
