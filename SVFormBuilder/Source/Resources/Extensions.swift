//
//  Extensions.swift
//  SVFormBuilder
//
//  Created by Srinivas on 10/03/18.
//  Copyright © 2018 Srinivas. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //Border
    func addBorderWithColor(borderWidth:CGFloat, borderColor:UIColor) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
    }
}
