//
//  StackView+ViewControllers.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 09/07/2021.
//

import UIKit

extension UIStackView {
	
	func addViewController(_ viewController: UIViewController, parent: UIViewController) {
		addArrangedSubview(viewController.view)
		parent.addChild(viewController)
		viewController.didMove(toParent: parent)
	}
	
	func removeViewController(_ viewController: UIViewController) {
		viewController.willMove(toParent: nil)
		removeArrangedSubview(viewController.view)
		viewController.view.removeFromSuperview()
		viewController.removeFromParent()
	}
	
	func insertViewController(_ viewController: UIViewController, at index: Int, parent: UIViewController) {
		insertArrangedSubview(viewController.view, at: index)
		parent.addChild(viewController)
		viewController.didMove(toParent: parent)
	}
}
