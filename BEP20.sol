// HSNv2 Freelance Dev.
// https://github.com/HSNv2/ERC20_TAX_BURNABLE_CHANGEOWNER_CONTRACT
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract BEP20 {
    string public name = "Your Token Name";
    string public symbol = "SYMBOL";
    uint8 public decimals = 9;
    uint256 public totalSupply;
    address public owner;
    address public taxAddress;
    uint256 public taxPercentage;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event TaxAddressChanged(address indexed oldTaxAddress, address indexed newTaxAddress);

    bool private reentrancyGuard;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier nonReentrant() {
        require(!reentrancyGuard, "Reentrancy guard");
        reentrancyGuard = true;
        _;
        reentrancyGuard = false;
    }

    constructor(uint256 initialSupply, address Tax_Address, uint256 Tax_Percentage) {
        totalSupply = initialSupply * 10**uint256(decimals);
        taxAddress = Tax_Address;
        taxPercentage = Tax_Percentage;
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function approve(address spender, uint256 value) public returns (bool success) {
        require(spender != address(0), "Invalid spender address");
        require(value <= totalSupply, "Allowance exceeds maximum limit");

        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) public nonReentrant returns (bool success) {
        require(from != address(0), "Invalid address");
        require(to != address(0), "Invalid address");
        require(balanceOf[from] >= value, "Insufficient balance");
        require(allowance[from][msg.sender] >= value, "Allowance exceeded");

        uint256 taxAmount = (value * taxPercentage) / 100;
        uint256 transferAmount = value - taxAmount;
        balanceOf[from] -= value;
        balanceOf[to] += transferAmount;
        allowance[from][msg.sender] -= value;
        balanceOf[taxAddress] += taxAmount;

        emit Transfer(from, to, transferAmount);
        emit Transfer(from, taxAddress, taxAmount);

        return true;
    }
    function transfer(address to, uint256 value) public nonReentrant returns (bool success) {
        require(to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= value, "Insufficient balance");
        require(value > 0, "Invalid transfer amount");

        uint256 taxAmount = (value * taxPercentage) / 100;
        balanceOf[msg.sender] -= (value - taxAmount);
        balanceOf[to] += (value - taxAmount);
        balanceOf[taxAddress] += taxAmount;

        emit Transfer(msg.sender, to, value - taxAmount);
        emit Transfer(msg.sender, taxAddress, taxAmount);

        return true;
    }

    function updateTax(uint256 newTaxPercentage) public onlyOwner {
        require(newTaxPercentage <= 100, "Tax percentage must be between 0 and 100");
        taxPercentage = newTaxPercentage;
    }

    function changeTaxAddress(address newTaxAddress) external onlyOwner {
        require(newTaxAddress != address(0), "Invalid TaxAddress");
        require(newTaxAddress != taxAddress, "New TaxAddress is the same as the current one");
        
        address oldTaxAddress = taxAddress;
        taxAddress = newTaxAddress;
        
        emit TaxAddressChanged(oldTaxAddress, newTaxAddress);
    }
    function burn(uint256 amount) public onlyOwner returns (bool success) {
        require(amount > 0, "Invalid amount");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        uint256 scaledAmount = amount * (10**uint256(decimals));
        require(totalSupply >= scaledAmount, "Burn amount exceeds total supply");

        balanceOf[msg.sender] -= scaledAmount;
        totalSupply -= scaledAmount;

        emit Transfer(msg.sender, address(0), scaledAmount);
        return true;
    }

    function changeOwner(address newOwner) public onlyOwner returns (bool success) {
        require(newOwner != address(0), "Invalid address");
        owner = newOwner;
        return true;
    }
}
