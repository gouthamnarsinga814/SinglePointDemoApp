//
//  XCTestCase+Extension.swift
//  SinglePointDemoAppTests
//
//  Created by GOUTHAM on 26/11/24.
//

import XCTest
import Combine
@testable import SinglePointDemoApp

final class BundleExtensionsTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    override func tearDown() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testReadFile_Success() {
        let bundle = Bundle(for: type(of: self)) // Test bundle
        let fileName = "TestFile.json"
        let expectedData = """
        {
            "name": "Test",
            "age": 30
        }
        """.data(using: .utf8)!
        
        let expectation = XCTestExpectation(description: "Read file successfully")
        
        // Test
        bundle.readFile(file: fileName)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { data in
                XCTAssertEqual(data, expectedData, "Data mismatch")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReadFile_FileNotFound() {
        let bundle = Bundle(for: type(of: self))
        let fileName = "NonExistentFile.json"
        
        let expectation = XCTestExpectation(description: "File not found error")
        
        // Test
        bundle.readFile(file: fileName)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertNotNil(error, "Error should not be nil")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Should not receive data for a non-existent file")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testDecodeable_Success() {
        struct TestModel: Codable, Equatable {
            let name: String
            let age: Int
        }
        
        let bundle = Bundle(for: type(of: self))
        let fileName = "TestFile.json"
        let expectedModel = TestModel(name: "Test", age: 30)
        
        let expectation = XCTestExpectation(description: "Decode JSON successfully")
        
        // Test
        bundle.decodeable(fileName: fileName)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTFail("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { (model: TestModel) in
                XCTAssertEqual(model, expectedModel, "Decoded model mismatch")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testDecodeable_DecodeError() {
        struct TestModel: Codable, Equatable {
            let name: String
            let age: Int
        }
        
        let bundle = Bundle(for: type(of: self))
        let fileName = "InvalidTestFile.json" // Assume this file has invalid JSON
        
        let expectation = XCTestExpectation(description: "Decode error")
        
        // Test
        bundle.decodeable(fileName: fileName)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    XCTAssertNotNil(error, "Error should not be nil")
                    expectation.fulfill()
                }
            }, receiveValue: { (_: TestModel) in
                XCTFail("Should not decode invalid JSON")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}

