//
//  APIServiceInterface.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol APIServiceInterface {
    func request<T: Decodable>(for request: Requestable, completion: @escaping (Result<APIHTTPDecodableResponse<T>, Error>) -> Void)
    func request(for request: Requestable, completion: @escaping (Result<APIHTTPDataResponse, Error>) -> Void)
}
