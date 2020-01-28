//
//  Reusable.swift
//  Weather
//
//  Created by Grigor Hakobyan on 4/20/19.
//  Copyright © 2019 Grigor Hakobyan. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

protocol Nibable {
    static var nib: UINib { get }
}

extension Nibable {
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: .main)
    }
}

extension UITableViewCell: Reusable, Nibable {}
extension UICollectionViewCell: Reusable, Nibable {}

extension UITableView {
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
                                                fatalError()
        }
        return cell
    }
    
    func register(_ cell: UITableViewCell.Type) {
        register(cell.nib, forCellReuseIdentifier: cell.reuseID)
    }
}

extension UICollectionView {
    func dequeueReusableCell<T>(ofType cellType: T.Type = T.self, at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseID,
                                             for: indexPath) as? T else {
                                                fatalError()
        }
        return cell
    }
    
    func register(_ cell: UICollectionViewCell.Type) {
        register(cell.nib, forCellWithReuseIdentifier: cell.reuseID)
    }
}
