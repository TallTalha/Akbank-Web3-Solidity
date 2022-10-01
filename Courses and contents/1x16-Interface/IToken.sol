// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;

interface IToken {
    // Fonksiyonlarda override gerekli
    function transferFrom(address from, address to, uint256 amount) external;
    function transfer(address to, uint256 amount) external;
    function balanceOf(address user) external view returns(uint256);

    // Eventlerde gerekli değil
    event Transfer(address indexed from, address indexed to, uint256 amount);
}