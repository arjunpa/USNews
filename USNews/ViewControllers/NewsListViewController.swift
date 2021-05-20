//
//  ViewController.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

class NewsListViewController: UIViewController {

    var articleListViewModel: ArticleListViewModelInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articleListViewModel?.fetchArticles()
    }
}

extension NewsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListViewModel?.numberOfArticles ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
}

