//
//  FamilySummaryViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 09/07/2021.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FamilySummaryViewController: UIViewController {
	
	private let presenter: FamilySummaryPresenting
	private let family: Family
	private let member: Member
	
	private let containerView = TileView()
	
	private let settingsButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "gearshape"), for: .normal)
		button.tintColor = Assets.Colors.action.color
		return button
	}()
	
	private let memberDetailsButton: UIButton = {
		let button = UIButton()
		button.setBackgroundImage(UIImage(systemName: "person"), for: .normal)
		button.tintColor = Assets.Colors.action.color
		return button
	}()
	
	private lazy var familyNameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.text = family.name
		label.textColor = Assets.Colors.textPrimary.color
		label.font = FontFamily.SFProText.bold.font(size: 20.0)
		return label
	}()
	
	init(presenter: FamilySummaryPresenting, family: Family, member: Member) {
		self.family = family
		self.member = member
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		setupUI()
		setupBindings()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		view.backgroundColor = Assets.Colors.backgroundWarm.color
		
		view.addSubview(containerView)
		containerView.backgroundColor = .white
		containerView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(settingsButton)
		settingsButton.snp.makeConstraints { make in
			make.top.left.equalToSuperview().inset(24.0)
			make.size.equalTo(32.0)
		}
		
		containerView.addSubview(memberDetailsButton)
		memberDetailsButton.snp.makeConstraints { make in
			make.top.right.equalToSuperview().inset(24.0)
			make.size.equalTo(32.0)
		}
		
		containerView.addSubview(familyNameLabel)
		familyNameLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.bottom.equalToSuperview().inset(24.0)
		}
	}
	
	private func setupBindings() {
		let input = FamilySummaryPresenterInput(
			settingsButtonTapped: settingsButton.rx.tap,
			memberDetailsButtonTapped: memberDetailsButton.rx.tap
		)
		
		presenter.transform(input: input)
	}
}
