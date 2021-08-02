//
//  UITableView+ReusableView.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/07/2021.
//

import UIKit

extension ReusableView where Self: UIView {
	static var defaultReuseIdentifier: String {
		return String(describing: self)
	}
}

extension UITableViewCell: ReusableView {}
 
extension UITableView {
 
	func register<T: UITableViewCell>(_: T.Type) {
		register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
	}
 
	func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
		guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
			fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
		}
		return cell
	}
}
