// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

import "./IToken.sol";

/// @title Vault
/// @notice Allows users to deposit and withdraw any token (?)
contract Vault {
    /// @dev User -> Token -> Balance
    mapping(address => mapping(IToken => uint256)) tokenBalances;

    function depositToken(IToken token, uint256 amount) external {
        token.transferFrom(msg.sender, address(this), amount);
        tokenBalances[msg.sender][token] += amount;
    }

    function withdrawToken(IToken token, uint256 amount) external {
        tokenBalances[msg.sender][token] -= amount;
        token.transfer(msg.sender, amount);
    }

    function getBalanceOf(address user, IToken token) external view returns(uint256) {
        return token.balanceOf(user);
    }
}