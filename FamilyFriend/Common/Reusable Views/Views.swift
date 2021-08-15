//
//  Views.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 05/08/2021.
//

import UIKit

let makeRoundedButton: () -> UIButton = {
	let roundedButton = UIButton(type: .roundedRect)
	roundedButton.backgroundColor = Assets.Colors.action.color
	roundedButton.layer.cornerRadius = 24.0
	roundedButton.titleLabel?.font = FontFamily.SFProText.bold.font(size: 15.0)
	roundedButton.setTitleColor(.white, for: .normal)
	return roundedButton
}

let makeTextField: () -> UITextField = {
	let textField = UITextField()
	textField.backgroundColor = Assets.Colors.backgroundInteractive.color
	textField.textColor = Assets.Colors.textPrimary.color
	textField.font = FontFamily.SFProText.regular.font(size: 17.0)
	textField.layer.cornerRadius = 24.0
	textField.layer.borderColor = Assets.Colors.action.color.withAlphaComponent(0.5).cgColor
	textField.layer.borderWidth = 1.0
	let padding = CGFloat(12.0)
	textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: padding, height: textField.frame.size.height))
	textField.leftViewMode = .always
	return textField
}
