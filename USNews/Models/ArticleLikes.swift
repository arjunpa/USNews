//
//  ArticleLikes.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

struct ArticleLikes: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case likes
    }
    
    let likes: Int
}
