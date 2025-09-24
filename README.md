# Fundraising smart contract

## 📜 Overview

The **Fund Me** contract is a simple crowdfunding dApp:

* Anyone can **fund** the contract with ETH.
* Each contribution is checked against a **minimum USD value** using a **Chainlink price feed** to convert ETH to USD in real time.
* The contract **owner** can withdraw the accumulated funds.

## 🧩 Key Features

* **Price Oracle Integration**: Uses Chainlink AggregatorV3Interface to fetch ETH/USD prices.
* **Access Control**: `onlyOwner` modifier restricts withdrawals to the deployer.
* **Gas Optimizations**: Leverages `constant`, `immutable`, and custom errors for efficiency.
* **State Management**: Tracks funders and amounts, and resets records after withdrawals.

## 🛠 Tech Stack

* **Solidity** ^0.8.x
* **Foundry** (Forge & Cast) for testing, deployment scripts, and local blockchain forking.

## 🧪 Tests

Foundry tests cover:

* Minimum funding requirements
* Correct accounting of contributions
* Owner-only withdrawals
* Accurate ETH/USD conversions using mocked price feeds

---

This project demonstrates best practices for building and testing a production-ready crowdfunding contract while integrating external oracles and emphasizing security and gas efficiency.

This repository contains the **Fund Me** smart contract built while following the [Cyfrin Updraft](https://updraft.cyfrin.io/) 
