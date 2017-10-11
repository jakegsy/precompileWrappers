pragma solidity ^0.4.17;

contract ModExp {

	bytes32 public res;

 
function f(bytes _base, bytes _exp, bytes _mod) public returns (bytes32 result){
    bool success;
    assembly {
      let call_addr_base := add(calldataload(4),4) 
      let call_addr_exp := add(calldataload(36),4) //32 bytes 
      let call_addr_mod := add(calldataload(68),4)
      calldatacopy(0x20,call_addr_base,0x20) //First location of call argument in call memory
      calldatacopy(0x40,call_addr_exp,0x20)
      calldatacopy(0x60,call_addr_mod,0x20)
      call_addr_base := add(call_addr_base,0x20) //32 bytes for data
      call_addr_exp := add(call_addr_exp,0x20)
      call_addr_mod := add(call_addr_mod,0x20)
      let loc := 0x80
      calldatacopy(loc,call_addr_base,mload(0x20))
      loc := add(loc,mload(0x20))
      calldatacopy(loc,call_addr_exp,mload(0x40))
      loc := add(loc,mload(0x40))
      calldatacopy(loc,call_addr_mod,mload(0x60))
      loc := add(loc,mload(0x60))
      //TODO Make some clever loop
      success := call(sub(gas,2000), 5, 0, 0x20, sub(loc,0x20), 0x0, 0x20)
      switch success case 0 {invalid}
      return(0x0,0x20)
    }
  }
  function toBytes(uint x) constant returns (bytes b){
      b = new bytes(32);
      for (uint i = 0; i < 32; i++){
          b[i] = byte(uint8(x/(2**(8*(31-i)))));
      }
  }
}
  
