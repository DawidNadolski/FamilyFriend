//
//  UIViewController+ChildViewControllers.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 03/08/2021.
//

import UIKit

extension UIViewController {

	func add(_ child: UIViewController, to subview: UIView? = nil, frame: CGRect? = nil) {
		addChild(child)

		if let frame = frame {
			child.view.frame = frame
		}

		if let subview = subview {
			subview.addSubview(child.view)
		} else {
			view.addSubview(child.view)
		}
		child.didMove(toParent: self)
	}

	func remove() {
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
}
