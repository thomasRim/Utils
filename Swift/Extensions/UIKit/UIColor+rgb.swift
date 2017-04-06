//
//  UIColor+rgb.swift
//  mio-group
//
//  Created by Vladimir Yevdokimov on 1/24/17.
//  Copyright © 2017 magnet. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func rgb(r rr:Float,g:Float,b:Float) -> UIColor {
        return UIColor.init(colorLiteralRed:rr/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }

    class func rgba(r rr:Float,g:Float,b:Float,a:Float) -> UIColor {
        return UIColor.init(colorLiteralRed:rr/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }

    class func rgb_hex(_ rgbValue:Int) -> UIColor {
        return UIColor.init(colorLiteralRed:((Float)((rgbValue & 0xFF0000) >> 16))/255.0,
                            green: ((Float)((rgbValue & 0x00FF00) >>  8))/255.0,
                            blue: ((Float)((rgbValue & 0x0000FF) >>  0))/255.0,
                            alpha: 1.0)
    }
}
