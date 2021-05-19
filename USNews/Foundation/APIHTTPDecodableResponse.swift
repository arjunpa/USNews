//
//  APIHTTPDecodableResponse.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

struct APIHTTPDataResponse {
    let data: Data
    let httpResponse: HTTPURLResponse?
}

struct APIHTTPDecodableResponse<T> where T:Decodable {
    let data: Data
    let decoded: T
    let httpResponse: HTTPURLResponse?
}
