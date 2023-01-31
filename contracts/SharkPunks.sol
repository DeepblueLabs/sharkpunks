// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/// @title SharkPunks (ς)
/// @author Deepblue Labs
/// @notice SharkPunks is a collection of 5000 unique sharkpunks
/// @custom:security-contact bussiness@deepbluelabs.co
contract SharkPunks is ERC721, ERC721Enumerable, Ownable, Pausable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    string _name = "SharkPunks";
    string _symbol = unicode"ς";
    uint256 mintLimit = 77;

    string public baseURI =
        "ipfs://bafybeictcqo54upeddwqaarynw24xur7bqp535js3rkeu2mx7qyfho5qle/";
    string public baseExtension = ".json";
    uint256 public cost = 0.111 ether;
    uint256 public maxSupply = 5000;
    uint256 public maxMintAmountPerTx = 20;

    mapping(address => uint256) public mintedPerAddress;

    modifier mintRequire(uint256 _minAmount) {
        require(
            _minAmount > 0 && _minAmount <= maxMintAmountPerTx,
            "SharkPunks: mint amount is not valid"
        );
        require(
            _tokenIdCounter.current() + _minAmount <= maxSupply,
            "SharkPunks: max supply reached"
        );
        _;
    }

    constructor() ERC721(_name, _symbol) {}

    /**
     * Mints SharkPunks
     */
    function mintShark(uint256 _minAmount)
        external
        payable
        mintRequire(_minAmount)
        whenNotPaused
    {
        require(msg.sender == tx.origin, "SharkPunks: no bots allowed");
        require(
            msg.value == cost * _minAmount,
            "SharkPunks: ether value sent is not correct"
        );
        require(
            mintedPerAddress[msg.sender] + _minAmount <= mintLimit,
            "SharkPunks: mint limit reached"
        );

        _mintLoop(msg.sender, _minAmount);
        mintedPerAddress[msg.sender] += _minAmount;
    }

    /**
     * Set some SharkPunks aside
     */
    function reserveSharkPunks() external onlyOwner {
        _mintLoop(msg.sender, 10);
    }

    function _mintLoop(address _receiver, uint256 _mintAmount) internal {
        for (uint256 i = 0; i < _mintAmount; i++) {
            _safeMint(_receiver, _tokenIdCounter.current());
            _tokenIdCounter.increment();
        }
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
        uint256 currentTokenId = 1;
        uint256 ownedTokenIndex = 0;

        while (
            ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
        ) {
            address currentTokenOwner = ownerOf(currentTokenId);

            if (currentTokenOwner == _owner) {
                ownedTokenIds[ownedTokenIndex] = currentTokenId;
                ownedTokenIndex++;
            }

            currentTokenId++;
        }

        return ownedTokenIds;
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        _tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    //only owner
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setmaxMintAmount(uint256 _maxMintAmountPerTx) public onlyOwner {
        maxMintAmountPerTx = _maxMintAmountPerTx;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _tokenId,
        uint256 _batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(_from, _to, _tokenId, _batchSize);
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
