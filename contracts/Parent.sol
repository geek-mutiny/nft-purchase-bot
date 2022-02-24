
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
import "./Child.sol";

pragma solidity >=0.7.0 <0.9.0;

contract Parent is Ownable{
     Child[] public children;
     address payable reciever;
     uint public mintAmount;
     address mintAddress;
     bytes32 mintMethod;

     fallback() payable external {}

     function setReciever(address payable _reciever) public {
         reciever = _reciever;
     }

     function getReciever() external view returns(address _reciever){
         _reciever = reciever;
     }

    event ChildCreated(address childAddress);
    event TransferEther(address childAddress,uint cost);

     function createChild(uint nums) external{
         for(uint i=0;i<nums; i++){
       Child child = new Child(mintAddress, mintAmount, reciever);  
       children.push(child);
       emit ChildCreated(address(child));
       }
     }

     function getChildren() external view returns(Child[] memory _children){
       _children = children;
     }  

     function transferEtherForEachChild(uint costForEach) external onlyOwner  {
         for(uint i=0;i<children.length; i++){
           address payable addr = payable(children[i]);
             addr.transfer(costForEach); 
             emit TransferEther(addr, costForEach);
       }
     }

     function buyMints() external onlyOwner   {
         for(uint i=0;i<children.length; i++){
             children[i].buyMint();
       }
     }

     function tranferAllToReciever() external onlyOwner  {
         for(uint i=0;i<children.length; i++){
             children[i].transferToDad();
       }
     } 

     function destroyAllChilds() external onlyOwner   {
         for(uint i=0;i<children.length; i++){
             children[i].destroyContract();
       }
       delete children;
     }
 }
