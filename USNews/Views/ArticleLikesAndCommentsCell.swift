//
//  ArticleLikesAndCommentsCell.swift
//  USNews
//
//  Created by Arjun P A on 21/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

class ArticleLikesAndCommentsCell: UITableViewCell {

    @IBOutlet private var likesCountLabel: UILabel!
    @IBOutlet private var commentsCountLabel: UILabel!
    
    func configure(with sectionViewModel: ArticleDetailSectionLikesAndComments) {
        self.likesCountLabel.text = sectionViewModel.likesDescription
        self.commentsCountLabel.text = sectionViewModel.commentsDescription
    }
}
