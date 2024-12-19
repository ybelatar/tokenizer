// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Token42 {

	string public Name = "Token42";
	string public Symbol = "TKN";
	uint public TotalSupply;
	mapping(address => uint) public balances;
	mapping(address => mapping(address => uint)) public allowances;


	address public creator;
	address[] public signatories;
	uint public requiredApprovals;

	

    constructor(uint256 _supply, address[] memory _signatories, uint _requiredApprovals) {
		require(_signatories.length > 0, "At least one signatory required");
		require(_requiredApprovals > 0 && _requiredApprovals <= _signatories.length, "Wrong number of required approvals");
		TotalSupply = _supply;
		creator = msg.sender;
		balances[creator] = _supply;
		requiredApprovals = _requiredApprovals;
		signatories = _signatories;
	}

	function name() external view returns (string memory) {
		return Name;
	}

	function symbol() external view returns (string memory) {
		return Symbol;
	}


	function totalSupply() external view returns (uint) {
		return TotalSupply;
	}

	function balanceOf(address _account) external view returns (uint) {
		return balances[_account];
	}

	event Transfer(address indexed from, address indexed to, uint256 _amount);
    event Approval(address indexed owner, address indexed spender, uint256 _amount);

	modifier onlyCreator() {
		require(msg.sender == creator, "Not the creator");
		_;
	}

	modifier onlySignatory() {
		bool isSignatory = false;
		address[] memory signers = signatories;
		for (uint i = 0; i < signers.length; i++) {
			if (msg.sender == signers[i]) {
				isSignatory = true;
				break;
			}
		}
		require(isSignatory, "Not allowed to sign");
		_;
	}
	
	function transfer(address _to, uint256 _amount) external returns (bool) {
		require(balances[msg.sender] >= _amount, "Insufficient balance");
		balances[msg.sender] -= _amount;
		balances[_to] += _amount;
		emit Transfer(msg.sender, _to, _amount);
		return true;
	}

	function allowance(address _owner, address _spender) external view returns (uint) {
		return allowances[_owner][_spender];
	}

	function approve(address _spender, uint256 _amount) external returns (bool) {
		allowances[msg.sender][_spender] = _amount;
		emit Approval(msg.sender, _spender, _amount);
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _amount) external returns (bool) {
		require(balances[_from] >= _amount, "Insufficient balance");
		require(allowances[_from][msg.sender] >= _amount, "Not approved for that amount");

		balances[_from] -= _amount;
		allowances[_from][msg.sender] -= _amount;

		balances[_to] += _amount;
		
		emit Transfer(_from, _to, _amount);
		return true;
	}

	function mint(address _to, uint256 _amount) external onlyCreator {
		emit Transfer(address(0), _to, _amount);
		TotalSupply += _amount;
		balances[_to] += _amount;
	}

}
