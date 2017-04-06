//
//  BaseView.swift
//  iApprove
//
//  Created by Vladimir Yevdokimov on 6/23/16.
//  Copyright © 2016 Magnet Inc. All rights reserved.
//

import Foundation
import UIKit

class BaseView: UIView {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initializeSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }

    func initializeSubviews() {
        let ident:String = "\(self.classForCoder)".components(separatedBy: ".").last!
        let view: UIView = Bundle.main.loadNibNamed(ident, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
    }
}
