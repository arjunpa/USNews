//
//  ArticleDetailViewModel.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol ArticleDetailViewModelInterface: AnyObject {
    
    var numberOfRows: Int {
        get
    }
    
    func retrieveLikesAndComments()
    func row(at index: Int) -> ArticleDetailSection?
}

protocol ArticleDetailViewUpdateDelegate: AnyObject {
    func updateView()
    func updateView(at index: Int)
}

final class ArticleDetailViewModel: ArticleDetailViewModelInterface {
    
    var numberOfRows: Int {
        return sections.count
    }
    
    private let article: Article
    
    private var sections: [ArticleDetailSection] = []
    
    private let detailRepository: ArticleDetailRepository
    
    weak var viewDelegate: ArticleDetailViewUpdateDelegate?
    
    init(article: Article, detailRepository: ArticleDetailRepository) {
        self.article = article
        self.detailRepository = detailRepository
        self.prepare()
    }
    
    private func prepare() {
        
        if let urlToImage = article.urlToImage {
            sections.append(.image(ArticleDetailSectionImage(url: URL(string: urlToImage))))
        } else {
             sections.append(.image(ArticleDetailSectionImage(url: nil)))
        }
        
        sections.append(.title(ArticleDetailSectionTitle(title: self.article.title,
                                                         author: self.article.author)))
        
        sections.append(.likesAndComments(ArticleDetailSectionLikesAndComments(likes: nil, comments: nil)))
        
        if let description = self.article.description {
            sections.append(.description(ArticleDetailSectionDescription(description: description)))
        }
    }
    
    func retrieveLikesAndComments() {
        
        guard let articleID = self.article.articleID else {
            return
        }
        
        self.detailRepository.retrieveLikesAndComments(articleID: articleID,
                                                       queue: .main)
        { [weak self] likesResult, commentsResult in
            
            guard let `self` = self else { return }
            
            var likes: Int?
            var comments: Int?
            
            switch likesResult {
            case .success(let articleLikes):
                likes = articleLikes.likes
            case .failure:
                break
            }
            
            switch commentsResult {
            case .success(let articleComments):
                comments = articleComments.comments
            case .failure:
                break
            }
            
            guard let likesNotNil = likes, let commentsNotNil = comments else {
                return
            }
            
            /*
            Here we get the combined result of both likes and comments. We find the index of the section dealing with likes and comments.
            */
            
            guard let index = self.sections.firstIndex(where: { section -> Bool in
                guard case .likesAndComments = section else { return false }
                return true
            })
            else
            {
                return
            }
            
            switch self.sections[index] {
            case .likesAndComments(let likesAndComments):
                likesAndComments.updateComments(comments: commentsNotNil)
                likesAndComments.updateLikes(likes: likesNotNil)
            default:
                break
            }
            
            self.viewDelegate?.updateView(at: index)
        }
    }
    
    func row(at index: Int) -> ArticleDetailSection? {
        self.sections[safe: index]
    }
}
