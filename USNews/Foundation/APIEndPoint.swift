//
//  APIEndPoint.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

enum APIEndPoint: String, URLFormable {
    case newsListAPI = "https://newsapi.org/v2/top-headlines"
    
    func asURL() throws -> URL {
        try self.rawValue.asURL()
    }
}
