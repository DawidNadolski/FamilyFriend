//
//  InitialViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 14/08/2021.
//

import UIKit

final class InitialViewController: UIViewController {
	
	private let presenter: InitialPresenting

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Welcome to Family Friend"
		label.textColor = Assets.Colors.action.color
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = FontFamily.SFProText.bold.font(size: 42.0)
		return label
	}()

	private let secondaryTextLabel: UILabel = {
		let label = UILabel()
		label.text = "Manage your family chores in a fun way and compete with other members by completing custom tasks"
		label.textColor = Assets.Colors.textSecondary.color
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = FontFamily.SFProText.semibold.font(size: 15.0)
		return label
	}()
	
	private let signInButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		button.setTitle("Sign in", for: .normal)
		button.backgroundColor = Assets.Colors.action.color
		return button
	}()
	
	private let signUpButton: UIButton = {
		let button = makeRoundedSecondaryButton()
		button.setTitle("Sign up", for: .normal)
		button.setTitleColor(Assets.Colors.action.color, for: .normal)
		button.backgroundColor = Assets.Colors.backgroundInteractive.color
		button.layer.borderColor = Assets.Colors.action.color.withAlphaComponent(0.5).cgColor
		button.layer.borderWidth = 1.0
		return button
	}()

	init(presenter: InitialPresenting) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		setupUI()
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}

	private func setupUI() {
		view.backgroundColor = Assets.Colors.backgroundWarm.color

		view.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(96.0)
			make.left.right.equalToSuperview().inset(24.0)
		}

		view.addSubview(secondaryTextLabel)
		secondaryTextLabel.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(24.0)
			make.left.right.equalToSuperview().inset(48.0)
		}

		view.addSubview(signInButton)
		signInButton.snp.makeConstraints { make in
			make.height.equalTo(60.0)
			make.top.equalTo(secondaryTextLabel.snp.bottom).offset(60.0)
			make.left.right.equalToSuperview().inset(24.0)
		}

		view.addSubview(signUpButton)
		signUpButton.snp.makeConstraints { make in
			make.height.equalTo(60.0)
			make.top.equalTo(signInButton.snp.bottom).offset(24.0)
			make.left.right.equalToSuperview().inset(24.0)
		}
	}
	
	private func setupBindings() {
		let input = InitialPresenterInput(
			signInButtonPressed: signInButton.rx.tap,
			signUpButtonPressed: signUpButton.rx.tap
		)
		
		presenter.transform(input: input)
	}
	
	private func setupNavigationBar() {
		navigationController?.isNavigationBarHidden = true
	}
}
