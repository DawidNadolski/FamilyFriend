//
//  CALayer+applyShadow.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 26/08/2021.
//

import UIKit

extension CALayer {

	func applyShadow(
		color: UIColor = Assets.Colors.textPrimary.color,
		alpha: Float = 0.5,
		x: CGFloat = 0.0,
		y: CGFloat = 2.0,
		blur: CGFloat = 4.0,
		spread: CGFloat = -2.0
	) {
		masksToBounds = false
		shadowColor = color.cgColor
		shadowOpacity = alpha
		shadowOffset = CGSize(width: x, height: y)
		shadowRadius = blur / 2.0
		if spread == 0 {
			shadowPath = nil
		} else {
			let dx = -spread
			let rect = bounds.insetBy(dx: dx, dy: dx)
			shadowPath = UIBezierPath(rect: rect).cgPath
		}
	}
}
