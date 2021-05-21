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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(Status.self, forKey: .status)
        self.totalResults = try container.decode(Int.self, forKey: .totalResults)
        
        /*
         Wrapping articles with `SafeDecodable` to prevent the failure of the entire collection in case a single article element fails at it.
         */
        
        self.articles = try container.decode([SafeDecodable<Article>].self,
                                             forKey: .articles).compactMap({ $0.underlyingBase })
    }
}

struct Article: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case author
        case title
        case description
        case content
        case urlToImage
        case url
    }
    
    let author: String?
    let title: String
    let description: String?
    let content: String?
    let urlToImage: String?
    let url: String?
}
