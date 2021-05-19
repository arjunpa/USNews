//
//  Request.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

typealias RequestParameters = [String: Any]
typealias RequestHeaders = [String: String]

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol Requestable {
    func asURLRequest() throws -> URLRequest
}

extension URLRequest: Requestable {
    
    func asURLRequest() throws -> URLRequest {
        return self
    }
}
