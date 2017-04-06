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

///Ago
let kStr_NdayX = "%d day%@"
let kStr_NhourX = "%d hour%@"
let kStr_NminuteX = "%d minute%@"
let kStr_NsecondX = "%d second%@"

class AppUtils: NSObject {
    
    class func showAlert(title:String?, message:String?, actions:[UIAlertAction]?) {
        
        let closeAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        
        var activeActions = [closeAction]
        
        if actions != nil {
            activeActions = actions!
        }
        
        let _ = AppUtils.showCredentialAlert(title: title, message: message, inputFields: nil, actions: activeActions)
    }
    
    class func showCredentialAlert(title:String?, message:String?, inputFields:[UITextField]?, actions:[UIAlertAction]) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message:  message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let textFields = inputFields {
            for var field in textFields {
                alert.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = field.placeholder
                    textField.text = field.text
                    textField.textColor = field.textColor
                    textField.textAlignment = field.textAlignment
                    textField.isSecureTextEntry = field.isSecureTextEntry
                    field = textField
                })
            }
        }
        
        
        for action in actions {
            alert.addAction(action)
        }

        DispatchQueue.main.async(execute: {
            UIApplication.shared.windows[0].rootViewController?.present(alert, animated: true, completion: nil)
        })
        
        return alert
        
    }
    
    class func updateNavBar(_ navBar:UINavigationBar?, withImage:UIImage?) {

        if let image = withImage, let bar = navBar {
            let bg = AppUtils.resizeImage(image, toSize: CGSize(width: bar.bounds.size.width, height: bar.bounds.size.height+20))

            bar.setBackgroundImage(bg, for: UIBarMetrics.default)
            bar.shadowImage = AppUtils.resizeImage(image, toSize: CGSize(width: bar.bounds.size.width, height: 1))
        }
    }
    
    fileprivate class func resizeImage(_ image:UIImage, toSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(toSize, false, 0.0);
        image.draw(in: CGRect(x: 0, y: 0, width: toSize.width, height: toSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!;
    }

    class func tintedImage(_ image:UIImage,toImageView imageView:UIImageView,withColor color:UIColor) {
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = color
    }

    class func firstCharacterInString(_ s: String) -> String {
        if s == "" {
            return ""
        }
        return "\(s.characters.first!)"
    }

    class func attrString(_ strng:String, attribs:[[String:AnyObject]],ranges:[NSRange]) -> NSAttributedString? {
        guard !strng.isEmpty else {
            return NSMutableAttributedString.init(string: "")
        }

        let attrStr:NSMutableAttributedString? = NSMutableAttributedString.init(string: strng)

        guard attribs.count == ranges.count else {
            return attrStr
        }

        for index in 0..<attribs.count {
            let attribute = attribs[index]
            let range = ranges[index]
            attrStr?.addAttributes(attribute, range: range)
        }
        return attrStr
    }

    class func timeAgoForDate(_ date:Date?, format:String?)->String {
        var timeAgo = ""

        let format = format ?? DateFormat.MMMMdd.rawValue
        let date = date ?? Date()

        let actualDate = Date().timeIntervalSince1970
        let estimateDate = date.timeIntervalSince1970
        
        let leftSecs:Int = Int(actualDate - estimateDate)
        
        if leftSecs <= 0 {
            timeAgo = date.stringWithFormat(format)
        } else {
            let days:Int = Int(leftSecs/(60*60*7))
            
            if days > 7 {
                timeAgo = date.stringWithFormat(format)
            } else if days >= 1 {
                timeAgo = String.init(format: kStr_NdayX, days,(days==1) ? "" : "s")
            } else {
                let hours:Int = Int(leftSecs/(60*60))
                if hours >= 1 {
                    timeAgo = String.init(format: kStr_NhourX, hours,(hours==1) ? "" : "s")
                } else {
                    let minutes:Int = Int(leftSecs/60)
                    if minutes >= 1 {
                        timeAgo = String.init(format: kStr_NminuteX, minutes,(minutes==1) ? "" : "s")
                    } else {
                        timeAgo = String.init(format: kStr_NsecondX, leftSecs, (leftSecs==1) ? "" : "s")
                    }
                }
            }
        }
        
        return timeAgo
    }
}

func stringToBool(_ string:String?) -> Bool {
    var res = false
    if string?.lowercased() == "true" || string == "1" || string?.lowercased() == "yes" {
        res = true
    }
    return res
}

func boolToString(_ bol:Bool) -> String {
    var res = "false"
    if bol { res = "true" }
    return res
}

