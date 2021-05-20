//
//  ArticleViewModel.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation
import Kingfisher

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
    
    func downloadImage(completion: @escaping (ImageDownloadState) -> Void)
    func cancelImageDownload()
}

final class ArticleViewModel: ArticleViewModelInterface {
    
    let title: String
    
    let author: String?
    
    let description: String?
    
    let imageURL: URL?
    
    let content: String?
    
    private var imageDownloadTask: DownloadTask?
    
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
    
    func downloadImage(completion: @escaping (ImageDownloadState) -> Void) {
        if let imageURL = self.imageURL {
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
    
    func cancelImageDownload() {
        self.imageDownloadTask?.cancel()
    }
}
