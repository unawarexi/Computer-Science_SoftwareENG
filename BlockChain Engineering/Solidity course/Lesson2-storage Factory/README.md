# Storage Factory Tutorial

## Introduction
In this tutorial, we'll explore the concept of a storage factory in Solidity. We'll cover various topics such as the factory pattern, 
- importing contracts into other contracts known as `composability`, 
- interacting with other contracts known as `inheritance, and overrides`.

### Factory Pattern
The factory pattern is a design pattern used to create instances of classes or contracts. In Solidity, it can be used to deploy multiple instances of a contract with different parameters.

### Basic Solidity: Importing Contracts into other Contracts
Solidity allows you to import other contracts into your contract using the `import` keyword. This enables code reuse and modularity.

### Composability
Composability refers to the ability to combine different components or contracts to create more complex systems. It's a key principle in Solidity development for building scalable and reusable code.

### Solidity `new` Keyword
The `new` keyword in Solidity is used to create instances of contracts dynamically at runtime.

### Importing Code in Solidity
Solidity allows you to import code from other files using the `import` statement. This makes code organization easier and promotes reusability.

### Basic Solidity: Interacting with other Contracts
Interacting with other contracts in Solidity involves using their `ABI (Application Binary Interface)` and address. This allows your contract to call functions and access data from other contracts on the blockchain.

### ABI (Application Binary Interface)
The ABI is a JSON file that specifies how to interact with a contract, including its functions, parameters, and return types.

# Basic Solidity: Inheritance & Overrides
Inheritance in Solidity allows you to create new contracts based on existing ones, inheriting their state variables and functions. Overrides are used to replace or extend functions inherited from a parent contract.

## Overrides vs Virtual Functions in Solidity Inheritance

## Overrides
Overrides are used in Solidity to replace a function defined in a parent contract with a new implementation in a child contract. When a function is marked as `override` in a child contract, it must have the same name and function signature (including return type) as the function it is overriding in the parent contract.

### When to use Overrides
- Use overrides when you want to completely replace the behavior of a function inherited from a parent contract.
- Overrides are useful when you need to customize the behavior of a function in a child contract without changing its name or function signature.

## Virtual Functions
Virtual functions in Solidity are functions declared in a parent contract that are intended to be overridden by child contracts. When a function is marked as `virtual`, it means that it can be overridden by a function with the same name and function signature in a child contract.

### When to use Virtual Functions
- Use virtual functions when you want to define a placeholder function in a parent contract that can be customized or extended by child contracts.
- Virtual functions provide a way to enforce a contract's interface while allowing child contracts to provide their own implementation.

## Example
```solidity
pragma solidity ^0.8.0;

contract Parent {
    function foo() virtual public returns (uint) {
        return 10;
    }
}

contract Child is Parent {
    function foo() override public returns (uint) {
        return 20;
    }
}
```
