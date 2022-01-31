pragma solidity >=0.4.25 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ERA is ERC20{
    using SafeMath for uint256;
    uint BRUN_FEE=3;
    uint MARKETING_FEE=3;
    address public owner;
    mapping(address=> bool) public excludedFromTax;
    
    constructor() ERC20('BORING ERA','ERA'){
        _mint(msg.sender,1000000*10**18);
        owner=msg.sender;
        excludedFromTax[msg.sender]=true;
    }
    function transfer(address recipient,uint256 amount) public override returns(bool){
        if(excludedFromTax[msg.sender]==true){
            _transfer(_msgSender(),recipient,amount);
        }else{
            uint burnAmount=amount.mul(BRUN_FEE)/100;
            uint marketingAmount=amount.mul(MARKETING_FEE)/100;
            _burn(_msgSender(),burnAmount);
            _transfer(_msgSender(),owner,marketingAmount);
            _transfer(_msgSender(),recipient,amount.sub(burnAmount).sub(marketingAmount));
        }
        return true;
    }
    function excludeFromTax(address user)public returns(bool){
        if(_msgSender()==owner){
            excludedFromTax[user]=true;
            return true;
        }else{
            return false;
        }
    }
    function joinGame(){
        
    }
}
