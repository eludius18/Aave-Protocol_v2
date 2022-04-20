// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import './Context.sol';
import './IERC721.sol';
import './SafeMath.sol';
import './Address.sol';
import './Ownable.sol';
import {ERC721} from './openzeppelin/contracts/token/ERC721/ERC721.sol';

contract NFT is ERC721 {
  uint256 public nextTokenId;
  address public admin;

  constructor() public ERC721('New NFT', 'NFT') {
    admin = msg.sender;
  }

  function mint(address to) external {
    require(msg.sender == admin, 'only admin');
    _safeMint(to, nextTokenId);
    nextTokenId++;
  }
}
