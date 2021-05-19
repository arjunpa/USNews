//
//  APIServiceError.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

enum APIServiceError: Error {
    
    enum URLFormableError: Error {
        case failed
    }
    
    enum URLEncodingErrorReason {
        case invalidURL
    }
    
    enum URLEncodingError: Error {
        case failed(URLEncodingErrorReason)
    }
    
    enum APIResponseErrorReason: Error {
        case httpStatusCodeFailure
    }
    
    enum APIResponseError: Error {
        case failed(APIResponseErrorReason)
    }
}
