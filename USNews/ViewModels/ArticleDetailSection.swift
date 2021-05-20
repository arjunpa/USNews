//
//  ArticleDetailSection.swift
//  USNews
//
//  Created by Arjun P A on 21/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation
import Kingfisher

enum ArticleDetailSection {
    case image(ArticleDetailSectionImage)
    case title(ArticleDetailSectionTitle)
    case likesAndComments(ArticleDetailSectionLikesAndComments)
    case description(ArticleDetailSectionDescription)
}

class ArticleDetailSectionImage {
    
    let url: URL?
    
    private var imageDownloadTask: DownloadTask?
    
    init(url: URL?) {
        self.url = url
    }
    
    func downloadImage(completion: @escaping (ImageDownloadState) -> Void) {
        if let imageURL = self.url {
            self.imageDownloadTask = KingfisherManager.shared.retrieveImage(with: imageURL)
            { result in
                switch result {
                case .success(let result):
                    completion(.image(result.image))
                case .failure(let error):
                    completion(.error(error))
                }
            }
        } else {
            completion(.noImage)
        }
    }
}

class ArticleDetailSectionTitle {
    let title: String
    
    init(title: String) {
        self.title = title
    }
}

class ArticleDetailSectionLikesAndComments {
    
    private var likes: Int?
    private var comments: Int?
    
    init(likes: Int?, comments: Int?) {
        self.likes = likes
        self.comments = comments
    }
    
    func updateLikes(likes: Int?) {
        self.likes = likes
    }
    
    func updateComments(comments: Int?) {
        self.comments = comments
    }
}

class ArticleDetailSectionDescription {
    
    let description: String
    
    init(description: String) {
        self.description = description
    }
}
