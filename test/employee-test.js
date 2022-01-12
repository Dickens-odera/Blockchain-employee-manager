const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Employee", function () {
  it("should deploy successfully", async function () {
    const Employee = await ethers.getContractFactory("Employee");
    const employeeContract = await Employee.deploy();
    await employeeContract.deployed();
  });
});
