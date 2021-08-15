//
//  MemberCell.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 27/07/2021.
//

import UIKit

final class MemberCell: UITableViewCell {
	
	private let containerView = TileView()
	
	private let avatarImageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(systemName: "person"))
		imageView.tintColor = Assets.Colors.action.color.withAlphaComponent(0.7)
		return imageView
	}()
	
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
	
	func update(with member: Member) {
		nameLabel.text = member.name
	}
	
	private func setupUI() {
		contentView.backgroundColor = Assets.Colors.backgroundWarm.color
		
		contentView.addSubview(containerView)
		containerView.backgroundColor = .white
		containerView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(8.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(avatarImageView)
		avatarImageView.snp.makeConstraints { make in
			make.size.equalTo(48.0)
			make.top.left.bottom.equalToSuperview().inset(8.0)
		}
		
		containerView.addSubview(nameLabel)
		nameLabel.snp.makeConstraints { make in
			make.left.equalTo(avatarImageView.snp.right).offset(8.0)
			make.right.equalToSuperview().inset(8.0)
			make.centerY.equalToSuperview()
		}
	}
}
