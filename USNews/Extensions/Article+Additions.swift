//
//  Article+Additions.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

extension Article {
    
    var articleID: String? {
        guard let url = self.url else {
            return nil
        }
        
        var urlComponents = URLComponents(string: url)
        urlComponents?.scheme = nil
        
        var replacementString = urlComponents?.url?.absoluteString.replacingOccurrences(of: "//", with: "/")
        replacementString = replacementString?.replacingOccurrences(of: "/", with: "-")
        replacementString = replacementString?.trimmingCharacters(in: CharacterSet(charactersIn: "-"))
        return replacementString ?? url
    }
}
