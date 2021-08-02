//
//  FeatureTileView.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 11/07/2021.
//

import UIKit

enum FamilyFeature {
	case ranking
	case members
	case tasks
	case shoppingList
}

final class FeatureTileView: UIView {
		
	let feature: FamilyFeature
	
	let tapRecognizer = UITapGestureRecognizer()
	
	private lazy var image: UIImage? = {
		getImage(for: feature)
	}()
	
	private lazy var primaryText: String = {
		getPrimaryText(for: feature)
	}()
	
	private lazy var secondaryText: String = {
		getSecondaryText(for: feature)
	}()
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView(image: image)
		imageView.tintColor = Assets.Colors.action.color.withAlphaComponent(0.7)
		return imageView
	}()
	
	private lazy var primaryTextLabel: UILabel = {
		let label = UILabel()
		label.text = primaryText
		label.textColor = Assets.Colors.textPrimary.color
		label.font = FontFamily.SFProText.semibold.font(size: 17.0)
		return label
	}()
	
	private lazy var secondaryTextLabel: UILabel = {
		let label = UILabel()
		label.text = secondaryText
		label.textColor = Assets.Colors.textSecondary.color
		label.font = FontFamily.SFProText.regular.font(size: 13.0)
		return label
	}()
	
	init(feature: FamilyFeature) {
		self.feature = feature
		
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
		
		addGestureRecognizer(tapRecognizer)
		
		addSubview(imageView)
		imageView.snp.makeConstraints { make in
			make.top.left.bottom.equalToSuperview().inset(8.0)
			make.size.equalTo(64.0)
		}
		
		addSubview(primaryTextLabel)
		primaryTextLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(12.0)
			make.left.equalTo(imageView.snp.right).offset(8.0)
			make.right.equalToSuperview().inset(8.0)
		}
		
		addSubview(secondaryTextLabel)
		secondaryTextLabel.snp.makeConstraints { make in
			make.top.equalTo(primaryTextLabel.snp.bottom).offset(4.0)
			make.left.equalTo(imageView.snp.right).offset(8.0)
			make.right.equalToSuperview().inset(8.0)
		}
	}
}

extension FeatureTileView {
	
	private func getImage(for feature: FamilyFeature) -> UIImage? {
		switch feature {
			case .ranking:
				return UIImage(systemName: "list.number")
			case .members:
				return UIImage(systemName: "person")
			case .tasks:
				return UIImage(systemName: "checkmark.circle")
			case .shoppingList:
				return UIImage(systemName: "bag")
		}
	}
	
	private func getPrimaryText(for feature: FamilyFeature) -> String {
		switch feature {
			case .ranking:
				return "Ranking"
			case .members:
				return "Members"
			case .tasks:
				return "Tasks"
			case .shoppingList:
				return "Shopping list"
		}
	}
	
	private func getSecondaryText(for feature: FamilyFeature) -> String {
		switch feature {
			case .ranking:
				return "Secondary text"
			case .members:
				return "Secondary text"
			case .tasks:
				return "Secondary text"
			case .shoppingList:
				return "Secondary text"
		}
	}
}
