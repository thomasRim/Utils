//
//  UIViewController+sourceSpinner.swift
//  mio-group
//
//  Created by Vladimir Yevdokimov on 2/7/17.
//  Copyright © 2017 magnet. All rights reserved.
//

import Foundation
import UIKit

internal var refreshActionCallback:(()-> (()->())? )?
internal let spinner = UIRefreshControl()

extension UIViewController {

    public func setupSourceSpinner(to:UIScrollView?, onSpin:(()-> (()->())? )?) {
        refreshActionCallback = onSpin
        spinner.addTarget(self, action: #selector(startRefresh), for: UIControlEvents.valueChanged)
        to?.addSubview(spinner)
    }

    internal func startRefresh() {
        if ((refreshActionCallback?()) != nil) {
            spinner.endRefreshing()
        }
    }
}
