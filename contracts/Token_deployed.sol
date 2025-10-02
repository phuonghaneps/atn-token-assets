/**
 *Submitted for verification at BscScan.com on 2025-08-23
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Token {
    string public name;
    string public symbol;
    uint public totalSupply;   // giữ kiểu uint để gần ABI cũ
    uint public decimals;

    mapping(address => uint) private _balances;
    mapping(address => mapping(address => uint)) private _allowed;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor(
        string memory _name,
        string memory _symbol,
        uint[] memory _numbers   // [_decimals, _supplyWithoutDecimals]
    ) {
        require(_numbers.length >= 2, "Bad params");
        require(_numbers[0] <= 30, "decimals too large");
        require(_numbers[1] > 0, "supply must be > 0");

        name = _name;
        symbol = _symbol;
        decimals = _numbers[0];
        totalSupply = _numbers[1] * 10 ** decimals;

        // ✅ thay tx.origin -> msg.sender
        _balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function balanceOf(address _owner) public view returns (uint) {
        return _balances[_owner];
    }

    function transfer(address _to, uint _value) public returns (bool) {
        require(_to != address(0), "transfer to zero");
        require(_balances[msg.sender] >= _value, "insufficient balance");

        _balances[msg.sender] -= _value;   // ✅ _value
        _balances[_to] += _value;          // ✅ _value
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value) public returns (bool) {
        require(_from != address(0) && _to != address(0), "zero addr");
        require(_balances[_from] >= _value, "insufficient balance");     // ✅ _value
        require(_allowed[_from][msg.sender] >= _value, "allowance low"); // ✅ _value

        _balances[_from] -= _value;                    // ✅ _value
        _allowed[_from][msg.sender] -= _value;         // ✅ _value
        _balances[_to] += _value;                      // ✅ _value
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) public returns (bool) {
        require(_spender != address(0), "approve to zero");
        _allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public view returns (uint) {
        return _allowed[_owner][_spender];
    }
}
