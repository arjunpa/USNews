//
//  APIEndPoint.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

enum APIEndPoint: String, URLFormable {
    case articleListAPI = "https://newsapi.org/v2/top-headlines"
    case articleLikes = "https://cn-news-info-api.herokuapp.com/likes/"
    case articleComments = "https://cn-news-info-api.herokuapp.com/comments/"
    
    func asURL() throws -> URL {
        try self.rawValue.asURL()
    }
}
