//
//  ArticleDetailTitleCell.swift
//  USNews
//
//  Created by Arjun P A on 21/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

class ArticleDetailTitleCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    
    @IBOutlet private var stackView: UIStackView!
    
    func configure(with sectionViewModel: ArticleDetailSectionTitle) {
        titleLabel.text = sectionViewModel.title
        
        self.authorLabel.text = sectionViewModel.author
        
        if sectionViewModel.author == nil {
            self.stackView.removeArrangedSubview(authorLabel)
        } else {
            self.stackView.addArrangedSubview(authorLabel)
        }
    }
}
