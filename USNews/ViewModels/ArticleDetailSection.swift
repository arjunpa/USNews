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
    let author: String?
    
    init(title: String, author: String?) {
        self.title = title
        self.author = author
    }
}

class ArticleDetailSectionLikesAndComments {
    
    private var likes: Int? {
        didSet {
            self.updateLikesDescription()
        }
    }
    
    private var comments: Int? {
        didSet {
            self.updateCommentsDescription()
        }
    }
    
    var likesDescription: String?
    
    var commentsDescription: String?
    
    init(likes: Int?, comments: Int?) {
        self.likes = likes
        self.comments = comments
        self.updateLikesDescription()
        self.updateCommentsDescription()
    }
    
    func updateLikes(likes: Int?) {
        self.likes = likes
    }
    
    func updateComments(comments: Int?) {
        self.comments = comments
    }
    
    private func updateLikesDescription() {
        guard let likes = self.likes else { return }
        
        self.likesDescription = "\(likes)"
    }
    
    private func updateCommentsDescription() {
        guard let comments = self.comments else { return }
        
        self.commentsDescription = "\(comments)"
    }
}

class ArticleDetailSectionDescription {
    
    let description: String
    
    init(description: String) {
        self.description = description
    }
}
