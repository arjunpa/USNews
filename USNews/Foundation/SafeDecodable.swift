//
//  SafeDecodable.swift
//  USNews
//
//  Created by Arjun P A on 21/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

import Foundation

/// Wrapes around the decodable types so that when used with collections, an error decoding one element won't result in failure of decoding the entire collection.
struct SafeDecodable<Base: Decodable>: Decodable {
    let underlyingBase: Base?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.underlyingBase = try? container.decode(Base.self)
    }
}
