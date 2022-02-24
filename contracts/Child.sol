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
    uint mintAmount;  // num of mint for each address
  //  bytes32 method;  // string of called method
    uint256[] tokenIds;
    IERC721 public parentNFT;
    constructor(address _mintAddress,uint _mintAmount, address _reciever){
    //, bytes32 _method){
       mintAddress = _mintAddress;
       reciever = _reciever;
       mintAmount = _mintAmount;
       parentNFT = IERC721(_mintAddress); 
   //    method = _method;
    }

    fallback() payable external {}

      function onERC721Received(
        address operator, 
        address from, 
        uint256 tokenId, 
        bytes calldata data) external override returns (bytes4) {   
        tokenIds.push(tokenId);
        return IERC721Receiver.onERC721Received.selector;
    } 

    function getTokens() external view returns(uint256[] memory _tokens){
       _tokens = tokenIds;
     }  

    function buyMint() external onlyOwner {
        bool status;
        bytes memory result;
        (status, result) = mintAddress.delegatecall(abi.encodePacked(bytes4(keccak256("mint(uint256)")), mintAmount));
    }

    function transferToDad() external onlyOwner {
          for(uint i=0;i<tokenIds.length; i++){
             parentNFT.transferFrom(address(this), reciever, tokenIds[i]);
       }
    }

    function destroyContract() external onlyOwner {
        address payable addr = payable(reciever);
        selfdestruct(addr);
  }

}
