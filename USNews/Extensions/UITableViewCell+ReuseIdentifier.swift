//
//  UITableViewCell+ReuseIdentifier.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

protocol ReuseIdentifier {
    static var reuseIdentifier: String { get }
}

protocol NibLoadable {
    static var nibName: String { get }
}

extension NibLoadable where Self: UITableViewCell {
    
    static var nibName: String {
        return String(describing: self)
    }
}

extension ReuseIdentifier where Self: UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifier {}
extension UITableViewCell: NibLoadable {}
