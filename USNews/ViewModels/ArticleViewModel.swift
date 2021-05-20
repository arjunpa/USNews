//
//  ArticleViewModel.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol ArticleViewModelInterface {
    
    var title: String {
        get
    }
    
    var author: String? {
        get
    }
    
    var description: String? {
        get
    }
    
    var imageURL: URL? {
        get
    }
    
    var content: String? {
        get
    }
    
}

final class ArticleViewModel: ArticleViewModelInterface {
    
    let title: String
    
    let author: String?
    
    let description: String?
    
    let imageURL: URL?
    
    let content: String?
    
    init(article: Article) {
        self.title = article.title
        self.author = article.author
        self.description = article.description
        if let urlToImage = article.urlToImage {
            self.imageURL = URL(string: urlToImage)
        } else {
            self.imageURL = nil
        }
        self.content = article.content
    }
}
