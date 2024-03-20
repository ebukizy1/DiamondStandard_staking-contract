

// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.9;
import "../interfaces/IERC20.sol";
import "./../libraries/Erc20AppStorage.sol";

contract RewardToken is IERC20{
     Erc20AppStorage.Erc20Reward internal s;


 function init()external{
        s.name = "emaxtoken";
        s.symbol = "EMX";
        s.decimal = 18;
        s.totalSupply = 1000000000;
        mint(msg.sender, s.totalSupply);
    }


    function totalSupply() external view returns (uint256){
        return s.totalSupply;
    }

     function name() external view returns (string memory){
        return s.name;
    }

     function decimal() external view returns (uint256){
        return s.decimal;
    }

     function symbol() external view returns (string memory){
        return s.symbol;
    }

       function balanceOf(address _address) external view returns (uint256){
        
        return s.balanceOf[_address];
    }

    function allowance(address owner, address spender) external view returns (uint256){
     return s.allowance[owner][spender];

    }
   function mint(address _to, uint256 _amount) private {

    // Increase the total supply
    s.totalSupply += _amount;

    // Assign the minted tokens to the specified account
    s.balanceOf[_to] += _amount;

    // Emit the Mint event
    emit Transfer(address(0), _to, _amount);
}
    

    function transfer(address _to, uint256 _amount) external returns (bool){
        require(_amount <= s.balanceOf[msg.sender], "insufficient funds");
        s.balanceOf[msg.sender] -= _amount;
        s.balanceOf[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
        
    }



    function approve(address spender, uint256 _value) external returns (bool){
        s.allowance[msg.sender][spender] = _value;
        emit Approval(msg.sender, spender, _value);
        return true;
    }


    function transferFrom(address _owner, address _recipent, uint amount) external returns (bool){
           require(s.balanceOf[_owner] >= amount, "Insufficient balance");
        require(amount <= s.allowance[_owner][_recipent],  "Insufficient allowance");
       s.balanceOf[_owner] -= amount;
        s.balanceOf[_recipent] += amount;
        s.allowance[_owner][_recipent] -= amount; 
        emit Transfer(_owner, _recipent, amount);       
        return true;
    }
}
