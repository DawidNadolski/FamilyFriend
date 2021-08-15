//
//  SignInViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 14/08/2021.
//

import UIKit

final class SignInViewController: UIViewController {

	private let emailTextfield: UITextField = {
		let textfield = makeTextField()
		textfield.placeholder = "E-mail"
		return textfield
	}()

	private let passwordTextfield: UITextField = {
		let textfield = makeTextField()
		textfield.placeholder = "Password"
		textfield.isSecureTextEntry = true
		return textfield
	}()

	private let signInButton: UIButton = {
		let button = makeRoundedButton()
		button.setTitle("Sign in", for: .normal)
		return button
	}()

	init() {
		super.init(nibName: nil, bundle: nil)
		setupUI()
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

		view.addSubview(emailTextfield)
		emailTextfield.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
		}

		view.addSubview(passwordTextfield)
		passwordTextfield.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(emailTextfield.snp.bottom).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
		}

		view.addSubview(signInButton)
		signInButton.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(passwordTextfield.snp.bottom).offset(48.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Sign in"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.tintColor = Assets.Colors.action.color
		navigationController?.navigationBar.standardAppearance = .largeClear
	}
}