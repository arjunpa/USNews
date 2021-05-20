//
//  UIStoryboard+Additions.swift
//  USNews
//
//  Created by Arjun P A on 20/05/21.
//  Copyright © 2021 Arjun P A. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum NamedStoryboard: String {
        case main
        
        var fileName: String {
            return self.rawValue.capitalized
        }
    }
    
    convenience init(storyboardName: NamedStoryboard, bundle: Bundle? = nil) {
        self.init(name: storyboardName.fileName, bundle: bundle)
    }
    
    func instantiateViewController<ViewController: UIViewController>() -> ViewController where ViewController: StoryboardInstantiable {
        guard let viewController = self.instantiateViewController(withIdentifier: ViewController.storyboardIdentifier) as? ViewController else {
            fatalError()
        }
        return viewController
    }
}
