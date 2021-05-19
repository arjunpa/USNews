//
//  SessionContext.swift
//  USNews
//
//  Created by Arjun P A on 19/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import Foundation

protocol SessionContext {
    var session: URLSession { get }
}

final class DataSessionContext: SessionContext {
    
    static let commonContext = DataSessionContext(session: .shared)
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
}
