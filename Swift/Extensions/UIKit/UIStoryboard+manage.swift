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


extension UIStoryboard {
    class func initiateStoryboard(_ storyboardName:String) {

        let sb = UIStoryboard(name: storyboardName, bundle: nil)

        if let controller = sb.instantiateInitialViewController() {
            let window = UIApplication.shared.windows[0]
            window.rootViewController = controller
            window.makeKeyAndVisible()
        }
    }

    class func initialControllerFrom(storyboard storyboardName:String) -> UIViewController? {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        let ctrlr = sb.instantiateInitialViewController()
        return ctrlr
    }

    class func controllerFrom(storyboard storyboardName:String, withId:String) -> UIViewController? {
        let sb = UIStoryboard(name: storyboardName, bundle: nil)
        let ctrlr = sb.instantiateViewController(withIdentifier: withId)
        return ctrlr
    }
}
