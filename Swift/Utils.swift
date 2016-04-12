//
//  Utils.swift
//
//
//  Created by Vladimir Yevdokimov on 6/22/15.
//  Copyright (c) 2015 home. All rights reserved.
//

import UIKit

class Utils: NSObject {
    class func stringFromClass(name: AnyClass) -> String {
        let ident:String = NSStringFromClass(name).componentsSeparatedByString(".").last!
        return ident
    }

    class func updateNavBar(navBar:UINavigationBar, withImage:UIImage) {

        var bg = Utils.resizeImage(withImage!, toSize: CGSize(width: navBar.bounds.size.width, height: navBar.bounds.size.height+20))

        navBar.setBackgroundImage(bg, forBarMetrics: UIBarMetrics.Default)
        navBar.shadowImage = Utils.resizeImage(withImage!, toSize: CGSize(width: navBar.bounds.size.width, height: 1))
    }

    class func resizeImage(image:UIImage, toSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(toSize, false, 0.0);
        image.drawInRect(CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
}