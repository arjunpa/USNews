//
//  ResponseValidatorTests.swift
//  USNewsTests
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import XCTest

@testable import USNews

final class ResponseValidatorTests: XCTestCase {
    
    func testHTTPOKStatus() {
        let validator = ResponseValidator.default
        
        let result = validator.validateResponse(data: Data(),
                                                response: HTTPURLResponse(url: URL(string: "https://www.google.com")!,
                                                             statusCode: 200,
                                                             httpVersion: "1.0",
                                                             headerFields: nil)!,
                                                error: nil)
        
        guard case .success(let response, _) = result else {
            XCTFail("Response validation failed even though the given url response has http status 200.")
            return
        }
        
        XCTAssertTrue(response != nil)
    }
    
    func testHTTPStatus300() {
        let validator = ResponseValidator.default
               
               let result = validator.validateResponse(data: Data(),
                                                       response: HTTPURLResponse(url: URL(string: "https://www.google.com")!,
                                                                    statusCode: 300,
                                                                    httpVersion: "1.0",
                                                                    headerFields: nil)!,
                                                       error: nil)
               
        guard case .failure(let error) = result else {
            XCTFail("Response validation passed even though status was 300")
            return
        }
               
        XCTAssertTrue(error is APIServiceError.APIResponseError)
    }
}
