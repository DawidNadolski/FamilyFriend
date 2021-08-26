//
//  TileView.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 09/07/2021.
//

import UIKit

final class TileView: UIView {

	init(backgroundColor: UIColor = UIColor.white, cornerRadius: CGFloat = 16.0) {
		super.init(frame: .zero)
		setupUI(backgroundColor: backgroundColor, cornerRadius: cornerRadius)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI(backgroundColor: UIColor, cornerRadius: CGFloat) {
		clipsToBounds = true
		layer.cornerRadius = cornerRadius
		layer.backgroundColor = backgroundColor.cgColor
		layer.applyShadow(alpha: 0.05, y: 4.0, blur: 20.0)
	}
}
