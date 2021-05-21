//
//  ArticleDetailViewController.swift
//  USNews
//
//  Created by Arjun P A on 21/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

class ArticleDetailViewController: UIViewController {

    private static let supportedCells: [UITableViewCell.Type] = [ArticleDetailImageCell.self,
                                                                 ArticleDetailTitleCell.self,
                                                                 ArticleLikesAndCommentsCell.self,
                                                                 ArticleDescriptionCell.self]
    
    private enum Constants {
         static let estimatedRowHeight: CGFloat = 100.0
     }
    
    @IBOutlet private var articleDetailTableView: UITableView!
    
    var detailViewModel: ArticleDetailViewModelInterface?
    
   // MARK: Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.detailViewModel?.retrieveLikesAndComments()
    }
}

// MARK: Private Methods
extension ArticleDetailViewController {
    
    private func setupUI() {
        self.articleDetailTableView.separatorStyle = .none
        self.articleDetailTableView.dataSource = self
        self.articleDetailTableView.rowHeight = UITableView.automaticDimension
        self.articleDetailTableView.estimatedRowHeight = Constants.estimatedRowHeight
        self.registerCells()
    }
    
    private func registerCells() {
        
        for cellType in type(of: self).supportedCells {
            self.articleDetailTableView.register(UINib(nibName: cellType.nibName,
                                                       bundle: nil),
                                                 forCellReuseIdentifier: cellType.reuseIdentifier)
        }
    }
}

extension ArticleDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailViewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let rowViewModel = self.detailViewModel?.row(at: indexPath.item)
        else {
            return UITableViewCell()
        }
        
        var cell: UITableViewCell?
        
        switch rowViewModel {
        case .image(let imageSection):
            let imageCell = tableView.dequeueReusableCell(withIdentifier: ArticleDetailImageCell.reuseIdentifier,
                                                 for: indexPath) as? ArticleDetailImageCell
            imageCell?.configure(with: imageSection)
            
            cell = imageCell
            
        case .title(let titleSection):
            let titleCell = tableView.dequeueReusableCell(withIdentifier: ArticleDetailTitleCell.reuseIdentifier,
                                                 for: indexPath) as? ArticleDetailTitleCell
            titleCell?.configure(with: titleSection)
            cell = titleCell
            
        case .likesAndComments(let likesAndComments):
            let likesAndCommentCell = tableView.dequeueReusableCell(withIdentifier: ArticleLikesAndCommentsCell.reuseIdentifier,
                                                                    for: indexPath) as? ArticleLikesAndCommentsCell
            likesAndCommentCell?.configure(with: likesAndComments)
            cell = likesAndCommentCell
            
        case .description(let descriptionSection):
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: ArticleDescriptionCell.reuseIdentifier, for: indexPath) as? ArticleDescriptionCell
            descriptionCell?.configure(with: descriptionSection)
            cell = descriptionCell
        }
        
        guard let cellValid = cell else {
            return UITableViewCell()
        }
        
        cellValid.selectionStyle = .none
        
        return cellValid
    }
}

extension ArticleDetailViewController: ArticleDetailViewUpdateDelegate {
    
    func updateView() {
        self.articleDetailTableView.reloadData()
    }
    
    func updateView(at index: Int) {
        self.articleDetailTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
}

extension ArticleDetailViewController: StoryboardInstantiable {}
