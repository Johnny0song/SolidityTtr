// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

// 简单的可升级合约，管理员可以通过升级函数更改逻辑合约地址，从而改变合约的逻辑。
contract SimpleUpgrade{
    address public implementation; // 逻辑合约地址
    address public admin;  // admin地址
    string public words;   // 字符串，可以通过逻辑合约的函数改变

    // 构造函数，初始化admin和逻辑合约地址
    constructor(address implementation_){
        admin = msg.sender;
        implementation = implementation_;
    }

    // fallback函数，将调用委托给逻辑合约
    fallback() external payable {
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
        if (success){

        }
        data;
    }

    // 升级函数，改变逻辑合约地址，只能由admin调用
    function upgrade(address newimplementation) external{
        require(msg.sender == admin);
        implementation = newimplementation;
    }

    receive() external payable{

    }
}

// 逻辑合约1
contract Logic1 {
    // 状态变量和proxy合约一致，防止插槽冲突
    address public implementation; 
    address public admin; 
    string public words; // 字符串，可以通过逻辑合约的函数改变

    // 改变proxy中状态变量，选择器： 0xc2985578
    function foo() public{
        words = "old";
    }

    function getSelector() external pure returns(bytes4){
        return bytes4(abi.encodeWithSignature("foo()"));
    }
}


// 逻辑合约2
contract Logic2 {
    // 状态变量和proxy合约一致，防止插槽冲突
    address public implementation; 
    address public admin; 
    string public words; // 字符串，可以通过逻辑合约的函数改变

    // 改变proxy中状态变量，选择器：0xc2985578
    function foo() public{
        words = "new";
    }
}