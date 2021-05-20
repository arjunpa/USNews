//
//  ArticleListDependencyBuilder.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

final class ArticleListDependencyBuilder {
    
    static func buildArticleList() -> ArticleListViewController {
        let rootViewController: ArticleListViewController = UIStoryboard(storyboardName: .main)
                                                            .instantiateViewController()
        let viewModel = ArticleListViewModel(repository: ArticleListRepository(apiService: APIService(),
                                                                               queue: .main))
        rootViewController.articleListViewModel = viewModel
        viewModel.viewDelegate = rootViewController
        return rootViewController
    }
}
