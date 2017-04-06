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

import UIKit

internal var bottomLayoutConstraint: NSLayoutConstraint?

extension UIViewController {

    //MARK: - Call to activate
    /**
     Call to activate
     */
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
    }

    func registerKeyboardNotifications(bottomConstraint:NSLayoutConstraint?) {
        bottomLayoutConstraint = bottomConstraint
        registerKeyboardNotifications()
    }
    //MARK: - May override to fetch activity
    /**
     Override to fetch activity
     */
    func keyboardDidShow() {

    }
    /**
     Override to fetch activity
     */
    func keyboardDidHide() {

    }


    //MARK: - Static
    /**
     Static
     */
    final func keyboardDidShow(_ notification:Notification) {
        if let info = (notification as NSNotification).userInfo {
            let size = (info["UIKeyboardFrameEndUserInfoKey"] as? NSValue)?.cgRectValue.size;
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.1, animations: { [weak self] in
                bottomLayoutConstraint?.constant = size?.height ?? 0
                self?.view.layoutIfNeeded()
                },completion: { [weak self](finished) in
                    self?.keyboardDidShow()
            })
        }
    }
    /**
     Static
     */
    final func keyboardDidHide(_ notification:Notification) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            bottomLayoutConstraint?.constant = 0
            self?.view.layoutIfNeeded()
            },completion: { [weak self](finished) in
                self?.keyboardDidHide()
        })
    }
}
