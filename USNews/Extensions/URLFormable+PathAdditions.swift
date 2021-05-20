//
//  URLFormable+PathAdditions.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

extension URLFormable {
    
    func appendingPathComponent(component: String) throws -> URLFormable {
        let url = try self.asURL()
        return url.appendingPathComponent(component)
    }
}
