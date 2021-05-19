//
//  RequestJSONEncoding.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

struct RequestJSONEncoding: RequestEncoding {
        
    func encode(_ request: Requestable, with parameters: RequestParameters?) throws -> URLRequest {
        var urlRequest = try request.asURLRequest()
        guard let parameters = parameters else { return urlRequest }
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        return urlRequest
    }
}
