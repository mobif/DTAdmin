//
//  TestStudent.swift
//  DTAdminTests
//
//  Created by Володимир on 06.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin

class TestStudent: XCTestCase {
    var sessionUnderTest: URLSession!
    override func setUp() {
        super.setUp()
        CommonNetworkManager.shared().logIn(username: "admin", password: "dtapi_admin") { (user, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(user)
            self.sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
        }
    }
    
    override func tearDown() {
        self.sessionUnderTest = nil
        super.tearDown()
    }
    
    func testAllManipulationStudent() {
        //Get Student with id = 0
        let id = "0"
        var testStudent: StudentStructure?
        var errorResponse: String?
        var testStudentId: String?
        weak var promise = expectation(description: "Test get fake student by Id")
        DataManager.shared.getEntity(byId: id, typeEntity: .Student) { (student, error) in
            testStudent = student as? StudentStructure
            errorResponse = error
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 8, handler: nil)
        XCTAssertNil(errorResponse)
        XCTAssertNotNil(testStudent)
        //Add requared fields for new student
        guard var studentInsert = testStudent else { return }
        studentInsert.userId = nil
        studentInsert.userName = "test_tra"
        studentInsert.email = "test1hjkl@tra.rara.ua"
        studentInsert.photo = nil
        studentInsert.gradebookId += "test"
        studentInsert.password = studentInsert.plainPassword
        studentInsert.passwordConfirm = studentInsert.password
        //Insert prepared student
        weak var promiseInsert = expectation(description: "Test insert of fake student")
        DataManager.shared.insertEntity(entity: studentInsert, typeEntity: .Student) { (newStudentId, error) in
            testStudentId = String(describing: newStudentId!)
            promiseInsert?.fulfill()
            promiseInsert = nil
        }
        waitForExpectations(timeout: 8, handler: nil)
        XCTAssertNotNil(testStudentId)
        guard let updateStudentId = testStudentId else { return }
        //Update student
        studentInsert.studentName = "TestedUser" //Someone field should be changed in instance for update (if not - error)
        weak var promiseEdit = expectation(description: "Test update of fake student")
        DataManager.shared.updateEntity(byId: updateStudentId, entity: studentInsert, typeEntity: .Student) { error in
            XCTAssertNil(error)
            promiseEdit?.fulfill()
            promiseEdit = nil
        }
        waitForExpectations(timeout: 8, handler: nil)
        //Check changes
        weak var promiseCheck = expectation(description: "Test get fake student by Id")
        DataManager.shared.getEntity(byId: updateStudentId, typeEntity: .Student) { (student, error) in
            testStudent = student as? StudentStructure
            errorResponse = error
            promiseCheck?.fulfill()
            promiseCheck = nil
        }
        waitForExpectations(timeout: 8, handler: nil)
        XCTAssertNil(errorResponse)
        XCTAssertNotNil(testStudent)
        XCTAssertEqual(testStudent?.studentName, studentInsert.studentName)
        //Remove fake student
        weak var promiseDelete = expectation(description: "Test delete of fake student")
        DataManager.shared.deleteEntity(byId: updateStudentId, typeEntity: .Student) { (response, error) in
            XCTAssertNil(error)
            promiseDelete?.fulfill()
            promiseDelete = nil
        }
        waitForExpectations(timeout: 8, handler: nil)
    }
    func testStudentByGroup() {
        let groupID = "1"
        var testListStudents: [StudentStructure]?
        var errorResult: String?
        weak var promise = expectation(description: "Get list students by group")
        DataManager.shared.getStudents(forGroup: groupID, withoutImages: true) {
            (studentList, error) in
            testListStudents = studentList
            errorResult = error
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(errorResult)
        XCTAssertNotNil(testListStudents)
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
