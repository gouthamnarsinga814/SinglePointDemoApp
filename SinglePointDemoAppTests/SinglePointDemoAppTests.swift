//
//  SinglePointDemoAppTests.swift
//  SinglePointDemoAppTests
//
//  Created by GOUTHAM on 25/11/24.
//

import XCTest
import Combine
@testable import SinglePointDemoApp

struct SinglePointModelDecode: Decodable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

// Mock DataProvider
class MockDataProvider: DataProvider {
    var mockResult: Result<[SinglePointModel], Error>!
    
    func decodeable<T: Decodable>(fileName: String) -> AnyPublisher<T, Error> {
        if let result = mockResult as? Result<T, Error> {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
    }
}

class SinglePointDemoAppTests: XCTestCase {
    
    var viewModel: SinglePointViewModel!
    var mockDataProvider: MockDataProvider!
    var disposables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockDataProvider = MockDataProvider()
        viewModel = SinglePointViewModel(dataProvider: mockDataProvider)
        disposables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockDataProvider = nil
        disposables = nil
        super.tearDown()
    }
    
    func testFetchSinglePointDetails_Success() {
        // Arrange
        
        let mockResponse = [try! SinglePointModel(from: SinglePointModelDecode.self as! Decoder)]
        mockDataProvider.mockResult = .success(mockResponse)
        
        let expectation = XCTestExpectation(description: "Fetch success")
        
        viewModel.$singlePointList
            .dropFirst() // Ignore initial value
            .sink { singlePointList in
                XCTAssertEqual(singlePointList.count, 2)
                XCTAssertEqual(singlePointList.first?.name, "Point1")
                expectation.fulfill()
            }
            .store(in: &disposables)
        
        // Act
        viewModel.fetchSinglePointDetails()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchSinglePointDetails_Failure() {
        // Arrange
        mockDataProvider.mockResult = .failure(URLError(.badServerResponse))
        
        let expectation = XCTestExpectation(description: "Fetch failure")
        
        viewModel.$singlePointList
            .dropFirst() // Ignore initial value
            .sink { singlePointList in
                XCTAssertEqual(singlePointList.count, 0)
                expectation.fulfill()
            }
            .store(in: &disposables)
        
        // Act
        viewModel.fetchSinglePointDetails()
        
        // Assert
        wait(for: [expectation], timeout: 1.0)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
