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
        static let backgroundColor = UIColor(red: 211.0/255.0, green: 211.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    }
    
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var authorLabel: UILabel!
    @IBOutlet private var topImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = Constants.backgroundColor
    }

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
