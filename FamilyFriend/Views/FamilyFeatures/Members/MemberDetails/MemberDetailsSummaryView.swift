//
//  MemberDetailsSummaryView.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 01/08/2021.
//

import UIKit

final class MemberDetailsSummaryView: UIView {
	
	let avatarImageView: UIImageView = {
		let imageView = UIImageView()
		return imageView
	}()
	
	let joinDateLabel: UILabel = {
		let label = UILabel()
		label.font = FontFamily.SFProText.regular.font(size: 8.0)
		return label
	}()
		
	init() {
		super.init(frame: .zero)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		
	}
}
