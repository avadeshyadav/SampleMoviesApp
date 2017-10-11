//
//  UIView+Additions.swift
//  SampleShopApp
//
//  Created by Avadesh Kumar on 11/10/17.
//  Copyright © 2017 organization. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func makeCornerRadiusWithValue(_ radius: CGFloat, borderColor: UIColor? = nil) {
        
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
        if borderColor != nil {
            
            self.layer.borderColor = borderColor?.cgColor
            self.layer.borderWidth = 0.5
        }
    }
    
    func height() -> CGFloat {
        return self.frame.size.height;
    }
    
    func width() -> CGFloat {
        return self.frame.size.width;
    }
    
    func x() -> CGFloat {
        return self.frame.origin.x
    }
    
    func y() -> CGFloat {
        return self.frame.origin.y
    }
    
    func addShadowWithColor(_ color: UIColor, offset: CGSize) {
        
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = offset
    }
}
