//
//  NewsListCell.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

class NewsListCell: UITableViewCell {

    private enum Constants {
        static let noImageName = "no-image-available"
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var topImageView: UIImageView!

    func configure(with articleViewModel: ArticleViewModelInterface) {
        titleLabel.text = articleViewModel.title
        descriptionLabel.text = articleViewModel.description
        authorLabel.text = articleViewModel.author
        
        self.topImageView.image = nil
        articleViewModel.downloadImage { [weak self] state in
            switch state {
            case .noImage, .error:
                self?.topImageView.image = UIImage(named: Constants.noImageName)
            case .image(let image):
                self?.topImageView.image = image
            }
        }
    }
    
}
