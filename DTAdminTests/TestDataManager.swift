//
//  TestDataManager.swift
//  DTAdminTests
//
//  Created by Володимир on 04.11.17.
//  Copyright © 2017 if-ios-077. All rights reserved.
//

import XCTest
@testable import DTAdmin



class TestDataManager: XCTestCase {
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
    //MARK: Testing getList
    func testGetListUsers() {
        weak var promise = expectation(description: "User list")
        var responseError: String?
        var users: [UserStructure]?
        DataManager.shared.getList(byEntity: .User) { (list, error) in
            responseError = error
            users = list as? [UserStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(users)
    }
    func testGetListStudents() {
        weak var promise = expectation(description: "Student list")
        var responseError: String?
        var students: [StudentStructure]?
        DataManager.shared.getList(byEntity: .Student) { (list, error) in
            responseError = error
            students = list as? [StudentStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(responseError)
        XCTAssertNil(students)
    }
    func testGetListGroup() {
        weak var promise = expectation(description: "Group list")
        var responseError: String?
        var groups: [GroupStructure]?
        DataManager.shared.getList(byEntity: .Group) { (list, error) in
            responseError = error
            groups = list as? [GroupStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(groups)
    }
    func testGetListAnswer() {
        weak var promise = expectation(description: "Answer list")
        var responseError: String?
        var answers: [AnswerStructure]?
        DataManager.shared.getList(byEntity: .Answer) { (list, error) in
            responseError = error
            answers = list as? [AnswerStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(responseError)
        XCTAssertNil(answers)
    }
    func testGetListFaculty() {
        weak var promise = expectation(description: "Faculty list")
        var responseError: String?
        var faculties: [FacultyStructure]?
        DataManager.shared.getList(byEntity: .Faculty) { (list, error) in
            responseError = error
            faculties = list as? [FacultyStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(faculties)
    }
    func testGetListQuestion() {
        weak var promise = expectation(description: "Question list")
        var responseError: String?
        var question: [QuestionStructure]?
        DataManager.shared.getList(byEntity: .Question) { (list, error) in
            responseError = error
            question = list as? [QuestionStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(responseError)
        XCTAssertNil(question)
    }
    func testGetListSpeciality() {
        weak var promise = expectation(description: "Speciality list")
        var responseError: String?
        var speciality: [SpecialityStructure]?
        DataManager.shared.getList(byEntity: .Speciality) { (list, error) in
            responseError = error
            speciality = list as? [SpecialityStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(speciality)
    }
    func testGetListSubject() {
        weak var promise = expectation(description: "Subject list")
        var responseError: String?
        var subject: [SubjectStructure]?
        DataManager.shared.getList(byEntity: .Subject) { (list, error) in
            responseError = error
            subject = list as? [SubjectStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(subject)
    }
    func testGetListTestDetail() {
        weak var promise = expectation(description: "TestDetail list")
        var responseError: String?
        var testDetail: [TestDetailStructure]?
        DataManager.shared.getList(byEntity: .TestDetail) { (list, error) in
            responseError = error
            testDetail = list as? [TestDetailStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(testDetail)
    }
    func testGetListTest() {
        weak var promise = expectation(description: "Test list")
        var responseError: String?
        var test: [TestStructure]?
        DataManager.shared.getList(byEntity: .Test) { (list, error) in
            responseError = error
            test = list as? [TestStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(test)
    }
    func testGetListTimeTable() {
        weak var promise = expectation(description: "TimeTable list")
        var responseError: String?
        var timeTable: [TimeTableStructure]?
        DataManager.shared.getList(byEntity: .TimeTable) { (list, error) in
            responseError = error
            timeTable = list as? [TimeTableStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(timeTable)
    }
    //MARK: Test Counting all entities
    func testCountingEntities() {
        var counts = [Entities: UInt]()
        for entity in Entities.allValues {
            weak var promise = expectation(description: "Counting entities")
            DataManager.shared.getCountItems(forEntity: entity) { (count, error) in
                counts[entity] = count
                XCTAssertNotEqual(count, 0)
                promise?.fulfill()
                promise = nil
            }
            waitForExpectations(timeout: 3, handler: nil)
        }
        XCTAssertNil(counts[.User])
        XCTAssertNotEqual(counts.count, Entities.allValues.count)
    }
    //MARK: Testing serving of entities
    
    
    
    //MARK: Testing getListRange
    func testGetListRangeUsers() {
        weak var promise = expectation(description: "User list")
        var responseError: String?
        var users: [UserStructure]?
        DataManager.shared.getListRange(forEntity: .User, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            users = list as? [UserStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(responseError)
        XCTAssertNil(users)
    }
    func testGetListRangeStudents() {
        weak var promise = expectation(description: "Student list")
        var responseError: String?
        var students: [StudentStructure]?
        DataManager.shared.getListRange(forEntity: .Student, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            students = list as? [StudentStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(students)
    }
    func testGetListRangeGroup() {
        weak var promise = expectation(description: "Group list")
        var responseError: String?
        var groups: [GroupStructure]?
        DataManager.shared.getListRange(forEntity: .Group, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            groups = list as? [GroupStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(groups)
    }
    func testGetListRangeAnswer() {
        weak var promise = expectation(description: "Answer list")
        var responseError: String?
        var answers: [AnswerStructure]?
        DataManager.shared.getListRange(forEntity: .Answer, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            answers = list as? [AnswerStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(answers)
    }
    func testGetListRangeFaculty() {
        weak var promise = expectation(description: "Faculty list")
        var responseError: String?
        var faculties: [FacultyStructure]?
        DataManager.shared.getListRange(forEntity: .Faculty, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            faculties = list as? [FacultyStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(faculties)
    }
    func testGetListRangeQuestion() {
        weak var promise = expectation(description: "Question list")
        var responseError: String?
        var question: [QuestionStructure]?
        DataManager.shared.getListRange(forEntity: .Question, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            question = list as? [QuestionStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(question)
    }
    func testGetListRangeSpeciality() {
        weak var promise = expectation(description: "Speciality list")
        var responseError: String?
        var speciality: [SpecialityStructure]?
        DataManager.shared.getListRange(forEntity: .Speciality, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            speciality = list as? [SpecialityStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(speciality)
    }
    func testGetListRangeSubject() {
        weak var promise = expectation(description: "Subject list")
        var responseError: String?
        var subject: [SubjectStructure]?
        DataManager.shared.getListRange(forEntity: .Subject, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            subject = list as? [SubjectStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(subject)
    }
    func testGetListRangeTestDetail() {
        weak var promise = expectation(description: "TestDetail list")
        var responseError: String?
        var testDetail: [TestDetailStructure]?
        DataManager.shared.getListRange(forEntity: .TestDetail, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            testDetail = list as? [TestDetailStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(testDetail)
    }
    func testGetListRangeTest() {
        weak var promise = expectation(description: "Test list")
        var responseError: String?
        var test: [TestStructure]?
        DataManager.shared.getListRange(forEntity: .Test, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            test = list as? [TestStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(test)
    }
    func testGetListRangeTimeTable() {
        weak var promise = expectation(description: "TimeTable list")
        var responseError: String?
        var timeTable: [TimeTableStructure]?
        DataManager.shared.getListRange(forEntity: .TimeTable, fromNo: 0, quantity: 1) { (list, error) in
            responseError = error
            timeTable = list as? [TimeTableStructure]
            promise?.fulfill()
            promise = nil
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(responseError)
        XCTAssertNotNil(timeTable)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
