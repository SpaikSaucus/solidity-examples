# Solidity examples for learning


Examples of Smart Contracts in Solidity with some challenges to practice.
Tips to understand some things.
Snippets and more...

## Table of Contents
- [Getting started](#getting-started)
- [Tips](#tips)
  - [default value](#default-value)
  - [max value](#max-value)
  - [public vs external](#public-vs-external)
  - [pure vs view](#pure-vs-view)
  - [memory vs calldata vs storage](#memory-vs-calldata-vs-storage)
  - [array vs mapping](#array-vs-mapping)
  - [interface](#interface)
  - [timestamp](#timestamp)
  - [unchecked](#unchecked)
  - [delegatecall](#delegatecall)
- [Snippets](#snippets)
  - [array](#array)
  - [unchecked](#unchecked-1)  
  - [interface](#interface-1)
- [License](#license)

## Getting Started

* Download
* Copy some file **.sol** in [Remix IDE](https://remix.ethereum.org) and enjoy!
* Recommended Pages:
    * [Ethereum Development Documentation](https://ethereum.org/en/developers/docs)
    * [Remix Documentation](https://remix-ide.readthedocs.io/en/latest)
    * [Solidity Documentation](https://docs.soliditylang.org)

## Tips
---
### default value
    The concept of "undefined" or "null" values ​​does not exist in Solidity, but newly declared variables always have a default value it depends on your type.
    
    uint:0
    int:0
    fixed:0.0 (warning: not fully supported)
    string:""
    boolean:false
    enum: the first element of the enum
    address:0x0
    array: a dynamically-sized []
    mapping: an empty mapping
    struct: a struct where all members are set to default values
    function: if internal, an empty function. If external, a function that throws an error when called.

### max value
    uint can store 2^256-1 numbers.
    int store half of it. e.g. 2^256/2-1 numbers.

    Int8 — [-128 : 127]
    int16 — [-32768 : 32767]
    Int32 — [-2147483648 : 2147483647]
    Int64 — [-9223372036854775808 : 9223372036854775807]
    int128 — [-170141183460469231731687303715884105728 : 170141183460469231731687303715884105727]
    Int256 — [-57896044618658097711785492504343953926634992332820282019728792003956564819968 : 57896044618658097711785492504343953926634992332820282019728792003956564819967]

    UInt8 — [0 : 255]
    UInt16 — [0 : 65535]
    UInt32 — [0 : 4294967295]
    UInt64 — [0 : 18446744073709551615]
    UInt128 — [0 : 340282366920938463463374607431768211455]
    UInt256 — [0 : 115792089237316195423570985008687907853269984665640564039457584007913129639935]


### public vs external
    Basically, public means it can be external or internal, the compiler needs additional work for the civil service. With the external, it allows to read arguments directly from calldata, skipping the copy step.

    So if you know that the function you create only allows external calls, choose external. Provides performance benefits and you'll save on gas.

### pure vs view
    The pure function declares that no state variables will be changed or read.

    pure tells us that the function not only does not save any data on the blockchain, it also does not read any data from the blockchain.

    view tells us that when executing the function, no data will be saved/changed.

    Pure and view functions cost gas if called internally from another function. They are only free if called externally, from outside the blockchain.

### memory vs calldata vs storage

    Use calldata when you only need read-only data, avoiding the cost of allocating memory or storage.

    Use memory if you want your argument to be mutable.

    Use storage if your argument will already exist in storage, to avoid copying something in memory storage unnecessarily.

### array vs mapping
 
* array has push, pop and length method
* array can be fixed [3] or dynamic []
* array can be looped, but if it's too big it can end up costing a lot of gas

* mapping is key-value
* mapping is accessed by the key
* mapping cannot be looped
* mapping does not have a recoverable length
* mapping is a hash table, it is much more efficient

### interface
    Through interfaces we can consume other Smart Contracts that are in the blockchain, in the tips section we can see an example.

### timestamp
    block.timestamp;

    Ethereum uses the Unix time representation for timestamps, you can use a utility like this to convert ranges of integers to dates

    Using uint8 should be fine until '1970-01-01T00:04:15+00:00'
    Using uint16 should be fine until '1970-01-01T18:12:15+00:00'
    Using uint32 should be good enough until '2106-02-07T06:28:15+00:00'
    Using uint64 should be valid for 584,942,417,355 years after 1970

### unchecked

> SafeMath is not needed for pragma >= 0.8.0. The compiler now implements what SafeMath does. 
> However the **unchecked** we can use it to optimize the gas. In te snippet secction

### delegatecall
    There is a special function in Solidity called DELEGATECALL that allows you to call another
    contract using the context of the caller, not that of the recipient.


## Snippets
---
### array

```solidity

  string fruit[];
  fruit = ["apple", "mango", "watermelon"];
  fruit.push("bacon");
  fruit.pop();

  //swap places with the last one and delete it
  function deleteArray(uint index) public {
    data[index] = data[data.length-1];
          data.pop();
  }

  //Error for writing outside the array:
  decoded output	{
    "error": "Failed to decode output: Error: overflow (fault=\"overflow\", operation=\"toNumber\", value=\"35408467139433450592217433187231851964531694900788300625387963629091585785856\", code=NUMERIC_FAULT, version=bignumber/5.5.0)"
  }
```

### unchecked

```solidity
  uint256 length = array.length;
  for(uint256 i = 0; i < length; i++) {
    doSomething(array[i]);
  }
```
    Every time i++ is done, overflow/underflow checks are performed.
    But we are already restricting i by length, (i < length), making those overflow/underflow checks.

    So we can rewrite the loop this way and potentially save a significant amount of gasoline:

```solidity
  uint256 length = array.length;
  for(uint256 i = 0; i < length;) {
    doSomething(array[i]);
    unchecked{ i++; }
  }
```

### interface

```solidity
  interface IProofOfHumanity {
      // https://etherscan.io/address/0xc5e9ddebb09cd64dfacab4011a0d5cedaf7c9bdb
      function isRegistered(address _submissionID) external view returns (bool);
  }

  contract Aux {
    function prueba() external {
        if(proofOfHumanity().isRegistered(msg.sender)){
        ...
        } else {
        ...
        }
    }
    function proofOfHumanity() private view returns (IProofOfHumanity) {
        return IProofOfHumanity(0xc5e9ddebb09cd64dfacab4011a0d5cedaf7c9bdb);
    }
  }
```

## License

Is licensed under [The MIT License](LICENSE.md).