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
    mapping(uint => bool) public employeeIdExists; //check that the supplied id exists
    mapping(address => EmployeeRecord) public employeesByUser; //to help keep track of who added this employee
    mapping(uint => EmployeeRecord) public employeeBioDataById; //helps fetch a single employee record by mapping instead of a loop

    constructor() public {}

    event NewEmployee(address indexed creator, address indexed employeeAddress, uint date); //for logging and listening to smart contract events on the blockchain

    //check that the provied employee address does not exists in the blockchain already
    modifier isMissingFromRecords(address employee){
        require(recordExists[employee] == false,"Employee record exists");
        _;
    }

    //check that this employee id exists
    modifier employeeExists(uint employeeId){
        require(employeeIdExists[employeeId] == true,"The given employee ID does not exist");
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
    * @return bool
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
    ) public onlyOwner isMissingFromRecords(_employee) returns(bool)
    {
        employeeIds.increment();
        uint currentEmployeeId = employeeIds.current();
        EmployeeRecord memory newEmployee = EmployeeRecord(currentEmployeeId, _phone,_firstName,_lastName,_email,_employee,_employeeNumber,_designation,_company);
        employeeRecords.push(newEmployee);
        recordExists[_employee] = true;
        employeeBioDataById[currentEmployeeId] = newEmployee;
        employeeIdExists[currentEmployeeId] = true;
        totalEmployees = totalEmployees.add(1);
        employeesByUser[msg.sender] = newEmployee;
        return true;
    }

    /**
    * @dev fetch all employees
    * @return array of employees
    */
    function listEmployees() public view returns(EmployeeRecord[] memory) {
        return employeeRecords;
    }

    /**
    * @dev get employee biodata by it's ID
    * @param _employeeId uint
    */
    function getEmployeeBioData(uint _employeeId) public view employeeExists(_employeeId) returns(
        uint id,
        uint phone,
        string memory firstName,
        string memory lastName,
        string memory email,
        address employeeAddress,
        uint employeeNumber,
        bytes memory designation,
        bytes memory company
    ){
        EmployeeRecord storage employee = employeeBioDataById[_employeeId];
        id = employee.id;
        phone = employee.phone;
        firstName = employee.firstName;
        lastName = employee.lastName;
        email = employee.email;
        employeeAddress = employee.employeeAddress;
        employeeNumber = employee.employeeNumber;
        designation = employee.designation;
        company = employee.company;
    }
}