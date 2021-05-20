//
//  ArticleDetailImageCell.swift
//  USNews
//
//  Created by Arjun P A on 21/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

class ArticleDetailImageCell: UITableViewCell {

    private enum Constants {
           static let noImageName = "no-image-available"
    }
    
    @IBOutlet private var detailImageView: UIImageView!
    
    func configure(with sectionViewModel: ArticleDetailSectionImage) {
        
        detailImageView.image = nil
        
        sectionViewModel.downloadImage { [weak self] state in
            switch state {
            case .noImage, .error:
                self?.detailImageView.image = UIImage(named: Constants.noImageName)
            case .image(let image):
                self?.detailImageView.image = image
            }
        }
    }
}
