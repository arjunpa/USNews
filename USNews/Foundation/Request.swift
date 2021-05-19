//
//  Request.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

struct Request: Requestable {
    
    let url: URLFormable
    let httpMethod: RequestMethod
    let parameters: RequestParameters?
    let headers: RequestHeaders?
    let encoding: RequestEncoding
    
    init(url: URLFormable,
         method: RequestMethod,
         parameters: RequestParameters?,
         headers: RequestHeaders?,
         encoding: RequestEncoding) {
        self.url = url
        self.httpMethod = method
        self.parameters = parameters
        self.headers = headers
        self.encoding = encoding
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(with: self.url, method: self.httpMethod, headers: self.headers)
        request.allHTTPHeaderFields = self.headers
        if let parameters = self.parameters {
            request = try self.encoding.encode(request, with: parameters)
        }
        return request
    }
}
