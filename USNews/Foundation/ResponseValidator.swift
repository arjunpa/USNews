//
//  ResponseValidator.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol ResponseValidating {
    func validateResponse(data: Data?, response: URLResponse, error: Error?) -> Result<(response: HTTPURLResponse?, data: Data), Error>
}

struct ResponseValidator: ResponseValidating {
    
    static let `default` = ResponseValidator()
    
    func validateResponse(data: Data?,
                          response: URLResponse,
                          error: Error?) -> Result<(response: HTTPURLResponse?, data: Data), Error> {
        if let error = error {
            return .failure(error)
        }
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            return .failure(APIServiceError.APIResponseError.failed(.httpStatusCodeFailure))
        }
        let responseData = data ?? Data()
        return .success((response: httpResponse, data: responseData))
    }
}
