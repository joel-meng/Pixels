//
//  File.swift
//  
//
//  Created by Joel Meng on 7/8/19.
//

import UIKit

extension UITableView {
    
    /// Register a cell for item with nib loaded by item's default table view cell nib name,
    /// e.g. `CityTableViewCell` for item `City`, with reusable cell identifier item's type,
    /// e.g. `City`
    /// - Parameter Type: Item's type
    func registerDefaultCell<T>(for item: T.Type) {
        register(Bundle.main.loadTableCellNib(for: T.self),
                 forCellReuseIdentifier: cellIdentifier(from: T.self))
    }
    
    /// Will dequeu a cell with `CellIdentifier` by item's type and cast to item's corresponding ReflexTableViewCell.
    /// - Parameter indexPath: <#indexPath description#>
    func dequeueDefaultReusableCell<T, C: ReflexTableViewCell<T>>(forIndexPath indexPath: IndexPath) -> C {
        return dequeueReusableCell(withIdentifier: cellIdentifier(from: T.self),
                                   for: indexPath) as! C
    }
}

fileprivate func cellIdentifier<T>(from itemType: T.Type) -> String {
    return String.name(of: itemType)
}
