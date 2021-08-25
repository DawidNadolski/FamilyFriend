//
//  TaskCell.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 31/07/2021.
//

import UIKit

final class TaskCell: UITableViewCell {
	
	private let containerView = TileView()
	
	private lazy var nameLabel: UILabel = {
		let label = UILabel()
		label.textColor = Assets.Colors.textPrimary.color
		label.font = FontFamily.SFProText.semibold.font(size: 17.0)
		return label
	}()
	
	private lazy var assigneeLabel: UILabel = {
		let label = UILabel()
		label.textColor = Assets.Colors.textSecondary.color
		label.font = FontFamily.SFProText.regular.font(size: 13.0)
		return label
	}()
	
	private lazy var xpPointsLabel: UILabel = {
		let label = UILabel()
		label.textColor = Assets.Colors.textSecondary.color
		label.font = FontFamily.SFProText.regular.font(size: 13.0)
		return label
	}()
	
	//TODO: Consider adding "Due to:" label
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(with task: Task) {
		nameLabel.text = task.name
		assigneeLabel.text = task.assignedMemberName
		xpPointsLabel.text = "\(task.xpPoints) XP"
		
		if task.completed {
			markTaskAsCompleted(task)
		}
	}
	
	private func markTaskAsCompleted(_ task: Task) {
		let strikeWidth = 1.5
		
		let attributedNameText = NSMutableAttributedString(string: "\(task.name)")
		attributedNameText.addAttribute(
			NSAttributedString.Key.strikethroughStyle,
			value: strikeWidth,
			range: NSMakeRange(0, attributedNameText.length)
		)
		nameLabel.attributedText = attributedNameText
		
		let attributedXpPointsText = NSMutableAttributedString(string: "\(task.xpPoints) XP")
		attributedXpPointsText.addAttribute(
			NSAttributedString.Key.strikethroughStyle,
			value: strikeWidth,
			range: NSMakeRange(0, attributedXpPointsText.length)
		)
		xpPointsLabel.attributedText = attributedXpPointsText
		
		let attributedAssigneeText = NSMutableAttributedString(string: "\(task.assignedMemberName)")
		attributedAssigneeText.addAttribute(
			NSAttributedString.Key.strikethroughStyle,
			value: strikeWidth,
			range: NSMakeRange(0, attributedAssigneeText.length)
		)
		assigneeLabel.attributedText = attributedAssigneeText
	}
	
	private func setupUI() {
		contentView.backgroundColor = Assets.Colors.backgroundWarm.color
		
		contentView.addSubview(containerView)
		containerView.backgroundColor = .white
		containerView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview().inset(8.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(nameLabel)
		nameLabel.snp.makeConstraints { make in
			make.top.left.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(xpPointsLabel)
		xpPointsLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().inset(16.0)
			make.right.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(assigneeLabel)
		assigneeLabel.snp.makeConstraints { make in
			make.top.equalTo(nameLabel.snp.bottom).offset(6.0)
			make.left.bottom.equalToSuperview().inset(16.0)
		}
	}
}
