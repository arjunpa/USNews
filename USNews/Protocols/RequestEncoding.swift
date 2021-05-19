//
//  RequestEncoding.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol RequestEncoding {
    func encode(_ request: Requestable, with parameters: RequestParameters?) throws -> URLRequest
}

struct GetRequestEncoding: RequestEncoding {
    
    func encode(_ request: Requestable, with parameters: RequestParameters?) throws -> URLRequest {
        return try RequestURLEncoding().encode(request, with: parameters)
    }
}

struct PostRequestEncoding: RequestEncoding {
    
    func encode(_ request: Requestable, with parameters: RequestParameters?) throws -> URLRequest {
        return try RequestJSONEncoding().encode(request, with: parameters)
    }
}
