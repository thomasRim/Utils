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

private var root_spinner:UIActivityIndicatorView?

public extension UIViewController {

    func startAnimateWait() {
        if root_spinner == nil {
            root_spinner = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            root_spinner!.color = UIColor.darkGray
            root_spinner!.hidesWhenStopped = true
            self.view.addSubview(root_spinner!)
            root_spinner!.center = self.view.center
            root_spinner!.startAnimating()
        }
    }

    func stopAnimateWait() {
        if root_spinner != nil {
            root_spinner!.stopAnimating()
            root_spinner!.removeFromSuperview()
            root_spinner = nil
        }
    }

}
