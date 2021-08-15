//
//  TileView.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 09/07/2021.
//

import UIKit

final class TileView: UIView {
	
	init() {
		super.init(frame: .zero)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		clipsToBounds = true
		layer.cornerRadius = 16.0
		layer.backgroundColor = UIColor.white.cgColor
		layer.shadowRadius = 5.0
		layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
		layer.shadowColor = Assets.Colors.textPrimary.color.cgColor
		layer.shadowOpacity = 0.05
	}
}
