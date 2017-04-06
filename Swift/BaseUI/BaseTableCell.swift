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

//MARK: - Interactional protocols

protocol BaseTableCellObjectDelegate:NSObjectProtocol {
    func shouldUpdateUIForObject(_ object:BaseTableCellObject)
}
extension BaseTableCellObjectDelegate { // optionality
    func shouldUpdateUIForObject(_ object:BaseTableCellObject) { print("undefined \(#function)")}
}

protocol SelectionDelegate : NSObjectProtocol {
    func didSelect(_ object:AnyObject, withValue value:AnyObject?)
}
extension SelectionDelegate { // optionality
    func didSelect(_ object:AnyObject, withValue value:AnyObject?) { print("undefined \(#function)")}
}

//MARK: - UI and Object protocols

protocol TableCellProtocol {
    var object:BaseTableCellObject? {get set}

    /// Here you should setup info to UI from BaseTableCellObject
    ///
    /// - Parameter object: An object that inherits BaseTableCellObject class
    func setup(fromObject object: BaseTableCellObject?)


    /// Here you should resign all possible keyboard interactors.
    func resignKeyboard()
}

extension TableCellProtocol {
    func resignKeyboard() { print(" \(#function) optional") }
}

protocol TableCellObjectProtocol {
    var index: IndexPath? {get set}
    weak var cell: BaseTableCell? {get set}
    weak var selectionDelegate:SelectionDelegate? {get set}
    weak var uiUpdateDelegate:BaseTableCellObjectDelegate? {get set}

    var cellClass:UITableViewCell.Type! {get}
}


//MARK: - Implementation

class BaseTableCell: UITableViewCell,TableCellProtocol {

    var object: BaseTableCellObject?

    func setup(fromObject object: BaseTableCellObject?) {
         fatalError(String(format:"internal func setInterface(fromObject object:BaseCollectionObject!) -> Should be overriden in %@", NSStringFromClass(self.classForCoder)));
    }
    func resignKeyboard() {
    }
}


class BaseTableCellObject:NSObject, TableCellObjectProtocol {

    var index: IndexPath?
    weak var cell: BaseTableCell?
    weak var selectionDelegate:SelectionDelegate?
    weak var uiUpdateDelegate:BaseTableCellObjectDelegate?

    var cellClass:UITableViewCell.Type! {
        get{
            fatalError(String(format: "internal func getCellClass() -> Should be overriden in %@", NSStringFromClass(self.classForCoder)));
        }
    }
}


//MARK: - Private, Comparable

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l >= r
    default:
        return !(lhs < rhs)
    }
}
