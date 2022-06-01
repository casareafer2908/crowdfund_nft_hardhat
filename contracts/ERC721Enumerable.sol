// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "./ERC721.sol";

abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
    // See {IERC721Enumerable-totalSupply}.
    function totalSupply() public view virtual override returns (uint256) {
        return _owners.length;
    }

    // See {IERC721Enumerable-tokenByIndex}.
    function tokenByIndex(uint256 index)
        public
        view
        virtual
        override
        returns (uint256)
    {
        require(
            index < _owners.length,
            "ERC721Enumerable: global index out of bounds"
        );
        return index;
    }

    // See {IERC721Enumerable-tokenOfOwnerByIndex}.
    function tokenOfOwnerByIndex(address owner, uint256 index)
        public
        view
        virtual
        override
        returns (uint256 tokenId)
    {
        require(
            index < balanceOf(owner),
            "ERC721Enumerable: owner index out of bounds"
        );
        uint256 count;
        for (uint256 i; i < _owners.length; i++) {
            if (owner == _owners[i]) {
                if (count == index) return i;
                else count++;
            }
        }
        revert("ERC721Enumerable: owner index out of bounds");
    }

    // See {IERC165-supportsInterface}.
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(IERC165, ERC721)
        returns (bool)
    {
        return
            interfaceId == type(IERC721Enumerable).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    // See https://github.com/OpenZeppelin/openzeppelin-contracts/issues/3106
    function _listUserNFTs(address contractAddress, address owner)
        internal
        view
        returns (uint256[] memory)
    {
        uint256 balance = IERC721Enumerable(contractAddress).balanceOf(owner);

        uint256[] memory tokens = new uint256[](balance);

        for (uint256 i = 0; i < balance; i++) {
            tokens[i] = (
                IERC721Enumerable(contractAddress).tokenOfOwnerByIndex(owner, i)
            );
        }

        return tokens;
    }
}
