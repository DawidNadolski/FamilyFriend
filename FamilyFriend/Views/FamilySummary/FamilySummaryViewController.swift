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
	private let containerView = TileView()
	
	private let moreButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
		button.tintColor = Assets.Colors.action.color
		return button
	}()
	
	private let settingsButton: UIButton = {
		let button = UIButton()
		button.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
		button.tintColor = Assets.Colors.action.color
		return button
	}()
		
	private let familyImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = Assets.Colors.backgroundCool.color
		imageView.layer.cornerRadius = 12.0
		imageView.image = UIImage(systemName: "photo")
		imageView.tintColor = Assets.Colors.backgroundWarm.color
		return imageView
	}()
	
	private let familyNameLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.text = "Nadolscy Family"
		label.font = UIFont(name: "SFProText", size: 24.0)
		return label
	}()
	
	init(presenter: FamilySummaryPresenting) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		
		setupUI()
		setupBindings()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		view.backgroundColor = Assets.Colors.backgroundCool.color
		
		view.addSubview(containerView)
		containerView.backgroundColor = .white
		containerView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(moreButton)
		moreButton.snp.makeConstraints { make in
			make.top.left.equalToSuperview().inset(24.0)
			make.size.equalTo(32.0)
		}
		
		containerView.addSubview(settingsButton)
		settingsButton.snp.makeConstraints { make in
			make.top.right.equalToSuperview().inset(24.0)
			make.size.equalTo(32.0)
		}
		
		containerView.addSubview(familyImageView)
		familyImageView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8.0)
			make.size.equalTo(96.0)
			make.centerX.equalToSuperview()
		}
		
		containerView.addSubview(familyNameLabel)
		familyNameLabel.snp.makeConstraints { make in
			make.top.equalTo(familyImageView.snp.bottom).offset(16.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.centerX.equalTo(familyImageView.snp.centerX)
			make.bottom.equalToSuperview().inset(16.0)
		}
	}
	
	private func setupBindings() {
		let input = FamilySummaryPresenterInput(
			moreButtonTapped: moreButton.rx.tap,
			settingsButtonTapped: settingsButton.rx.tap
		)
		
		presenter.transform(input: input)
	}
}
