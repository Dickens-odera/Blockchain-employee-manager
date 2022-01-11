//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
* @title Employee
* @dev A simple smart contract that stores employee data on the Ethereum blockchain
* @author Dickens Odera https://github.com/Dickens-odera
*/
contract Employee is Ownable{
    using SafeMath for uint256;
    using Counters for Counters.Counter;

    uint public totalEmployees = 0; //to help keep track of the total number of employees
    Counters.Counter private employeeIds; //keeps track of each employee by a specicif unique id

    //employee details groiped together of different data types
    struct EmployeeRecord{
        uint id;
        uint phone;
        string firstName;
        string lastName;
        string email;
        address payable employeeAddress;
        uint employeeNumber;
        bytes designation;
        bytes company;
    }

    EmployeeRecord[] public employeeRecords;

    mapping(address => bool) public recordExists; // to help check whether the employee exists before adding them via the isMissingFromRecords modifier
    mapping(address => EmployeeRecord) public employeesByUser; //to help keep track of who added this employee

    constructor() public {}

    event NewEmployee(address indexed creator, address indexed employeeAddress, uint date); //for logging and listening to smart contract events on the blockchain
    //check that the provied employee address does not exists in the blockchain already
    modifier isMissingFromRecords(address employee){
        require(recordExists[employee] == false,"Employee record exists");
        _;
    }

    /**
    * @dev adds a new employee to the Blockchain
    * @param _phone uint
    * @param _employee address
    * @param _firstName string
    * @param _lastName string
    * @param _email string
    * @param _employeeNumber uint
    * @param _designation bytes
    * @param _company bytes
    */
    function addEmployee(
        uint _phone, 
        address payable _employee, 
        string memory _firstName, 
        string memory _lastName, 
        string memory _email,
        uint _employeeNumber,
        bytes memory _designation,
        bytes memory _company
    ) 
    public onlyOwner isMissingFromRecords(_employee) returns(bool)
    {
        employeeIds.increment();
        uint currentEmployeeId = employeeIds.current();
        EmployeeRecord memory newEmployee = EmployeeRecord(currentEmployeeId, _phone,_firstName,_lastName,_email,_employee,_employeeNumber,_designation,_company);
        employeeRecords.push(newEmployee);
        recordExists[_employee] = true;
        totalEmployees = totalEmployees.add(1);
        employeesByUser[msg.sender] = newEmployee;
        return true;
    }

}