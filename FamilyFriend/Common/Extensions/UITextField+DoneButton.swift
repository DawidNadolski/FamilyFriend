//
//  UITextField+DoneButton.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 24/08/2021.
//

import UIKit

extension UITextField {
	
	func addDoneButtonToKeyboard() {
		let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
		doneToolbar.barStyle = UIBarStyle.default
		
		let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneAction))
		done.tintColor = Assets.Colors.action.color
		
		var items = [UIBarButtonItem]()
		items.append(flexSpace)
		items.append(done)
		
		doneToolbar.items = items
		doneToolbar.sizeToFit()
		
		self.inputAccessoryView = doneToolbar
	}
	
	@objc private func doneAction() {
		self.resignFirstResponder()
	}
}
