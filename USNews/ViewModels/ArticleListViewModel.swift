//
//  ArticleListViewModel.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol ArticleListViewModelInterface {
    var numberOfArticles: Int { get }
    func fetchArticles()
    func articleAtIndex(index: Int) -> ArticleViewModelInterface?
}

protocol ArticleListUpdateViewDelegate: AnyObject {
    func updateView()
    func updateOnError(error: Error)
}

final class ArticleListViewModel: ArticleListViewModelInterface {
    
    var numberOfArticles: Int {
        return self.articleViewModels.count
    }
    
    func articleAtIndex(index: Int) -> ArticleViewModelInterface? {
        return self.articleViewModels[safe: index]
    }
    
    
    private let repository: ArticleListRepository
    
    weak var viewDelegate: ArticleListUpdateViewDelegate?
    
    private var articleViewModels: [ArticleViewModel] = []
    
    init(repository: ArticleListRepository) {
        self.repository = repository
    }
    
    func fetchArticles() {
        self.repository.fetchArticles(completion: { result in
            switch result {
            case .success(let response):
                self.articleViewModels = response.articles.map { ArticleViewModel(article: $0) }
                
                self.viewDelegate?.updateView()
            case .failure(let error):
                self.viewDelegate?.updateOnError(error: error)
            }
        }, queue: .main)
    }
}
