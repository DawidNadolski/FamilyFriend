//
//  UINavigationBar+Appearance.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 14/08/2021.
//

import UIKit

extension UINavigationBarAppearance {
	
	static var largeClear: UINavigationBarAppearance {
		let appearance = UINavigationBarAppearance()
		let largeTextAttributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: Assets.Colors.action.color,
			.font: FontFamily.SFProText.bold.font(size: 27.0)
		]
		
		appearance.configureWithTransparentBackground()
		appearance.backgroundColor = .clear
		appearance.largeTitleTextAttributes = largeTextAttributes
		
		return appearance
	}
}
