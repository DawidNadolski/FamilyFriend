//
//  FamilySettingsViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 29/08/2021.
//

import RxSwift

final class FamilySettingsViewController: UIViewController {
	
	private let presenter: FamilySettingsPresenting

	private let containerView = TileView()
	private let disposeBag = DisposeBag()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Settings"
		label.textAlignment = .center
		label.textColor = Assets.Colors.textPrimary.color
		label.font = FontFamily.SFProText.bold.font(size: 20.0)
		return label
	}()
		
	private let familyInfoButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		button.setTitle("Family info", for: .normal)
		return button
	}()
	
	private let abandonFamilyButton: UIButton = {
		let button = makeRoundedSecondaryButton()
		button.setTitle("Abandon family", for: .normal)
		return button
	}()
	
	private let logoutButton: UIButton = {
		let button = makeRoundedSecondaryButton()
		button.setTitle("Log out", for: .normal)
		return button
	}()
	
	private let cancelButton: UIButton = {
		let button = makeRoundedSecondaryButton()
		button.setTitle("Cancel", for: .normal)
		return button
	}()

	init(presenter: FamilySettingsPresenting) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		setupUI()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {
		view.backgroundColor = UIColor.black.withAlphaComponent(0.35)

		view.addSubview(containerView)
		containerView.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(28.0)
			make.centerY.equalToSuperview()
		}

		containerView.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(16.0)
			make.left.right.equalToSuperview()
		}

		containerView.addSubview(familyInfoButton)
		familyInfoButton.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(32.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.height.equalTo(48.0)
			make.centerX.equalToSuperview()
		}

		containerView.addSubview(abandonFamilyButton)
		abandonFamilyButton.snp.makeConstraints { make in
			make.top.equalTo(familyInfoButton.snp.bottom).offset(8.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.height.equalTo(48.0)
			make.centerX.equalToSuperview()
		}
		
		containerView.addSubview(logoutButton)
		logoutButton.snp.makeConstraints { make in
			make.top.equalTo(abandonFamilyButton.snp.bottom).offset(8.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.height.equalTo(48.0)
			make.centerX.equalToSuperview()
		}
		
		containerView.addSubview(cancelButton)
		cancelButton.snp.makeConstraints { make in
			make.top.equalTo(logoutButton.snp.bottom).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.height.equalTo(48.0)
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().inset(32.0)
		}
	}

	private func setupBindings() {
		let input = FamilySettingsPresenterInput(
			familyInfoButtonPressed: familyInfoButton.rx.tap,
			abandonFamilyButtonPressed: abandonFamilyButton.rx.tap,
			logoutButtonPressed: logoutButton.rx.tap,
			cancelButtonPressed: cancelButton.rx.tap
		)
		
		presenter.transform(input)
	}
}
