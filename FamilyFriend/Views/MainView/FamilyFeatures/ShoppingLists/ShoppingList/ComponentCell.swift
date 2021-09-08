//
//  ComponentCell.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 06/08/2021.
//

import UIKit

final class ComponentCell: UITableViewCell {
	
	private let containerView = TileView()
	
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.textColor = Assets.Colors.textPrimary.color
		label.font = FontFamily.SFProText.semibold.font(size: 17.0)
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(with component: ShoppingListComponent) {
		nameLabel.text = component.name
	}
	
	private func setupUI() {
		contentView.backgroundColor = Assets.Colors.backgroundWarm.color
		
		contentView.addSubview(containerView)
		containerView.backgroundColor = .white
		containerView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(8.0)
			make.height.equalTo(48.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(nameLabel)
		nameLabel.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(12.0)
			make.centerY.equalToSuperview()
		}
	}
}
