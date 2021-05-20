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
    
    func configure(with sectionViewModel: ArticleDetailSectionTitle) {
        titleLabel.text = sectionViewModel.title
    }
}
