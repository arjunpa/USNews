//
//  ArticleListResponse.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

struct ArticleListResponse: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case status
        case totalResults
        case articles
    }
    
    enum Status: String, Decodable {
        case ok
        case other = ""
    }
    
    let status: Status
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case author
        case title
        case description
        case content
    }
    
    let author: String
    let title: String
    let description: String
    let content: String
}
