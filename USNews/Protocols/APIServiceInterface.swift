//
//  APIServiceInterface.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol APIServiceInterface {
    /**
     Makes a http request using the provided abstract request.
     - parameters:
        - request: A type that conforms to `Requestable` that can be transformed into a `URLRequest`.
        - completion: The completion handler that is invoked once the request is completed with data or error,
     */
    func request<T: Decodable>(for request: Requestable,
                               completion: @escaping (Result<APIHTTPDecodableResponse<T>, Error>) -> Void)
    func request(for request: Requestable,
                 completion: @escaping (Result<APIHTTPDataResponse, Error>) -> Void)
}
