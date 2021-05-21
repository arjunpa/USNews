//
//  RequestEncoding.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol RequestEncoding {
    
    /**
    Encode a request with the provided parameters.
    - parameters:
      - request: A type conforming to `Requestable` that can be transformed into a URLRequest.
      - parameters: The parameters to be encoded into the request.
    */
    func encode(_ request: Requestable, with parameters: RequestParameters?) throws -> URLRequest
}
