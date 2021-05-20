//
//  ImageDownloadState.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

enum ImageDownloadState {
    case image(UIImage)
    case noImage
    case error(Error)
}
