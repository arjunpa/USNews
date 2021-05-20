//
//  ViewController.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

// MARK: Main Implementation

final class ArticleListViewController: UIViewController {

    private enum Constants {
        static let estimatedRowHeight: CGFloat = 100.0
    }
    
    @IBOutlet private var tableView: UITableView!
    
    var articleListViewModel: ArticleListViewModelInterface?
    
    // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.articleListViewModel?.fetchArticles()
    }
}

// MARK: Private Methods
extension ArticleListViewController {
    
    private func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = Constants.estimatedRowHeight
        self.registerCells()
    }
    
    private func registerCells() {
        self.tableView.register(UINib(nibName: NewsListCell.nibName,
                                      bundle: nil),
                                forCellReuseIdentifier: NewsListCell.reuseIdentifier)
    }
}

// MARK: UITableViewDataSource Implementation

extension ArticleListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListViewModel?.numberOfArticles ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.reuseIdentifier,
                                                       for: indexPath) as? NewsListCell,
              let rowViewModel = self.articleListViewModel?.articleAtIndex(index: indexPath.row)
        else {
            return UITableViewCell()
        }
        
        cell.configure(with: rowViewModel)
        return cell
    }
}

// MARK: UITableViewDelegate Implementation

extension ArticleListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.articleListViewModel?.cancelImageDownloadAtIndex(index: indexPath.row)
    }
}

// MARK: ArticleListUpdateViewDelegate Implementation

extension ArticleListViewController: ArticleListUpdateViewDelegate {
    
    func updateView() {
        self.tableView.reloadData()
    }
    
    func updateOnError(error: Error) {
        
    }
}

extension ArticleListViewController: StoryboardInstantiable {}
