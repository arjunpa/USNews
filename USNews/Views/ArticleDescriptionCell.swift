//
//  ArticleDescriptionCell.swift
//  USNews
//
//  Created by Arjun P A on 21/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

class ArticleDescriptionCell: UITableViewCell {

    @IBOutlet private var descriptionLabel: UILabel!
    
    func configure(with sectionViewModel: ArticleDetailSectionDescription) {
        descriptionLabel.text = sectionViewModel.description
    }
}
