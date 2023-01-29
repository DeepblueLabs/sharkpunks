// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @custom:security-contact bussiness@deepbluelabs.co
contract SharkPunks is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    string public _name = "SharkPunks";
    string public _symbol = unicode"ς";
    uint256 public _totalSupply = 1250;

    string public baseTokenURI = "https://nftstorage.link/ipfs/bafybeiecwxziu3oczxgz75amhwwjm2nwcn5dormkcibbs27t5nncakedk4/";

    constructor() ERC721(_name, _symbol) {}

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function internalMint() public onlyOwner {
        require(
            _tokenIdCounter.current() < _totalSupply,
            "SharkPunks: All tokens have been minted"
        );
        safeMint(msg.sender, _baseURI());
    }

    function safeMint(address to, string memory uri) private onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
