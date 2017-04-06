/*
 * Copyright (c) 2015 Magnet Systems, Inc.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you
 * may not use this file except in compliance with the License. You
 * may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
 * implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

import Foundation
import UIKit

extension UIViewController {
    func updateNavBar() {
        updateNavBar(UIImage(named: "bg_navbar"), tintColor: UIColor.rgb_hex(0xd4c1b6), titleFontSize: 20)
    }

    func updateNavBar(_ image:UIImage?, tintColor:UIColor, titleFontSize:CGFloat) {
        if self.navigationController != nil {
            AppUtils.updateNavBar(self.navigationController!.navigationBar, withImage: image!)
            self.navigationController?.navigationBar.tintColor = tintColor
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : tintColor,
                NSFontAttributeName : UIFont.systemFont(ofSize: titleFontSize)
            ]
        }
    }

    func setNavigationTitleText(_ text:String?) {
        if navigationController != nil {
            let tl = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            tl.text = text
            tl.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
            tl.textColor = navigationController?.navigationBar.tintColor
            tl.sizeToFit()
            navigationItem.titleView = tl
        }
    }

    func setNavigationTitleImage(_ image:UIImage?) {
        if navigationController != nil {
            let iv = UIImageView(image: image)
            navigationItem.titleView = iv
        }
    }
}
