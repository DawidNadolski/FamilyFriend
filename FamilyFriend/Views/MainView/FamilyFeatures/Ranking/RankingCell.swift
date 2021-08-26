//
//  RankingCell.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 25/08/2021.
//

import UIKit

final class RankingCell: UITableViewCell {
	
	private let containerView = TileView()
	
	private let positionLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	private let memberNameLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	private let pointsLabel: UILabel = {
		let label = UILabel()
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(with position: RankingPosition) {
		positionLabel.text = "\(position.place)"
		memberNameLabel.text = position.memberName
		pointsLabel.text = "\(position.points)"
	}
	
	private func setupUI() {
		contentView.backgroundColor = Assets.Colors.backgroundWarm.color
		
		contentView.addSubview(containerView)
		containerView.snp.makeConstraints { make in
			make.height.equalTo(48)
			make.top.bottom.equalToSuperview().inset(8.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(positionLabel)
		positionLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.left.equalToSuperview().inset(8.0)
			make.width.equalTo(48)
		}
		
		containerView.addSubview(memberNameLabel)
		memberNameLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.left.equalTo(positionLabel.snp.right).offset(16.0)
			make.width.equalTo(128.0)
		}
		
		containerView.addSubview(pointsLabel)
		pointsLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.left.equalTo(memberNameLabel.snp.right).offset(16.0)
			make.right.equalToSuperview().inset(8.0)
		}
	}
}
