//
//  UIStoryboard.swift
//  TestModule
//
//  Created by Rodion on 08.07.18.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

// MARK: - UIStoryboard
extension UIStoryboard {
    
    static func getVC(fromStoryboard: String, withIdentifire: String? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: fromStoryboard, bundle: nil)
        if let identufure = withIdentifire {
            return storyboard.instantiateViewController(withIdentifier: identufure)
        }
        
        return storyboard.instantiateInitialViewController()
    }
}
