//
//  UITableViewCell.swift
//  TestModule
//
//  Created by Rodion on 29.07.2018.
//  Copyright © 2018 Rodion Negov. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static var reuseId: String {
        return String(describing: self)
    }
}
