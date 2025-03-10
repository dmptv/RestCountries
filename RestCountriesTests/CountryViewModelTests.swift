//
//  CountryViewModelTests.swift
//  RestCountriesTests
//
//  Created by Kanat on 24.02.2025.
//

import XCTest
@testable import RestCountries

final class CountryViewModelTests: XCTestCase {
    let viewModel = CountryViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchCountries2() {
        let expectation = self.expectation(description: "Fetch Countries")

        viewModel.loadCountries()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else {
                XCTAssertNil(self, "Self is nil")
                expectation.fulfill()
                return
            }
            XCTAssertFalse(self.viewModel.countries.isEmpty)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchCountries() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockJSONDecoder: JSONDecoding {
    var result: Decodable?
    var error: Error?

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        if let error = error {
            throw error
        }
        if let result = result as? T {
            return result
        }
        fatalError("Mock decoder failed")
    }
}
