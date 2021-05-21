//
//  Article+AdditionsTests.swift
//  USNewsTests
//
//  Created by Arjun P A on 21/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

import XCTest

@testable import USNews

class ArticleAdditionsTests: XCTestCase {
    
    private enum Stubs {
        static let validArticleDict: [String: Any] = [
            "title": "Research on Bizarre Rodent Genetics Solves a Mystery",
            "description": "Open up Scott Roy’s Twitter bio and you’ll see a simple but revealing sentence.",
            "url": "https://scitechdaily.com/research-on-bizarre-rodent-genetics-solves-a-mystery-and-then-things-got-even-stranger",
            "urlToImage": "https://scitechdaily.com/images/Taiwan-Vole.jpg",
            "publishedAt": "2021-05-20T01:56:53Z",
            "content": "A Taiwan vole, closely related to the creeping vole described in the study."
        ]
        
        static let validArticleDictWithSlash: [String: Any] = [
            "title": "Research on Bizarre Rodent Genetics Solves a Mystery",
            "description": "Open up Scott Roy’s Twitter bio and you’ll see a simple but revealing sentence.",
            "url": "https://www.eonline.com/news/1271478/mariska-hargitay-hospitalized-after-suffering-multiple-leg-injuries/",
            "urlToImage": "https://scitechdaily.com/images/Taiwan-Vole.jpg",
            "publishedAt": "2021-05-20T01:56:53Z",
            "content": "A Taiwan vole, closely related to the creeping vole described in the study."
        ]
        
        static let articleWithoutURL: [String: Any] = [
            "title": "Research on Bizarre Rodent Genetics Solves a Mystery",
            "description": "Open up Scott Roy’s Twitter bio and you’ll see a simple but revealing sentence.",
            "urlToImage": "https://scitechdaily.com/images/Taiwan-Vole.jpg",
            "publishedAt": "2021-05-20T01:56:53Z",
            "content": "A Taiwan vole, closely related to the creeping vole described in the study."
        ]
    }
    
    func testArticleIDWithoutTrailingSlash() {
        guard let article = try? JSONDecoder().decode(Article.self, with: Stubs.validArticleDict) else {
            XCTFail("The json is expected to pass decoding.")
            return
        }
        
        XCTAssertTrue(article.articleID == "scitechdaily.com-research-on-bizarre-rodent-genetics-solves-a-mystery-and-then-things-got-even-stranger")
    }
    
    func testArticleIDWithTrailingSlash() {
        guard let article = try? JSONDecoder().decode(Article.self, with: Stubs.validArticleDictWithSlash) else {
            XCTFail("The json is expected to pass decoding.")
            return
        }
        
        XCTAssertTrue(article.articleID == "www.eonline.com-news-1271478-mariska-hargitay-hospitalized-after-suffering-multiple-leg-injuries")
    }
    
    func testArticleIDNil() {
        guard let article = try? JSONDecoder().decode(Article.self, with: Stubs.articleWithoutURL) else {
            XCTFail("The json is expected to pass decoding.")
            return
        }
        
        XCTAssertTrue(article.articleID == nil)
    }
}
