//
//  JSONDecoder+JSON.swift
//  USNews
//
//  Created by Arjun P A on 21/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    func decode<T: Decodable>(_ type: T.Type, with json: Any) throws -> T {
        let jsonData = try JSONSerialization.data(withJSONObject: json, options: [])
        return try JSONDecoder().decode(type, from: jsonData)
    }
}
