//
//  URLRequest+RequestMethod.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

extension URLRequest {
    
    var requestMethod: RequestMethod? {
        guard let httpMethod = self.httpMethod else { return nil }
        return RequestMethod(rawValue: httpMethod)
    }
    
    /**
     Initialize a request from supported parameters that can be transformed to a `URLRequest`.
     - Parameters:
        - url: A type conforming to `URLFormable` that can be transformed to a `URL`.
        - method: The method to be used with the http request.
        - headers: The headers to be used with the request.
     */
    init(with url: URLFormable,
         method: RequestMethod,
         headers: [String: String]?) throws {
        self.init(url: try url.asURL())
        self.httpMethod = method.rawValue
        self.allHTTPHeaderFields = headers
    }
}
