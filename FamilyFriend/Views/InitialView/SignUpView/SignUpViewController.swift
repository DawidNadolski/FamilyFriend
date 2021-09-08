//
//  SignUpViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 14/08/2021.
//

import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {
	
	private let presenter: SignUpPresenting
	
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)
	private let disposeBag = DisposeBag()

	private let emailTextfield: UITextField = {
		let textfield = makeTextField()
		textfield.placeholder = "E-mail"
		return textfield
	}()

	private let passwordTextfield: UITextField = {
		let textfield = makeTextField()
		textfield.placeholder = "Password (at least 8 characters)"
		textfield.isSecureTextEntry = true
		return textfield
	}()

	private let repeatPasswordTextfield: UITextField = {
		let textfield = makeTextField()
		textfield.placeholder = "Repeat password"
		textfield.isSecureTextEntry = true
		return textfield
	}()

	private let signUpButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		button.setTitle("Sign up", for: .normal)
		return button
	}()
	
	private let passwordsNotEqualLabel: UILabel = {
		let label = UILabel()
		label.text = "Entered passwords are not equal!"
		label.textColor = Assets.Colors.warning.color
		label.textAlignment = .center
		label.numberOfLines = 0
		label.font = FontFamily.SFProText.regular.font(size: 15.0)
		return label
	}()

	init(presenter: SignUpPresenting) {
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

		view.addSubview(repeatPasswordTextfield)
		repeatPasswordTextfield.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(passwordTextfield.snp.bottom).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(passwordsNotEqualLabel)
		passwordsNotEqualLabel.snp.makeConstraints { make in
			make.top.equalTo(repeatPasswordTextfield.snp.bottom).offset(12.0)
			make.left.right.equalToSuperview()
		}

		view.addSubview(signUpButton)
		signUpButton.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(passwordsNotEqualLabel.snp.bottom).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(activityIndicatorView)
		activityIndicatorView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(signUpButton.snp.bottom).offset(64.0)
		}
	}
	
	private func setupBindings() {
		let input = SignUpPresenterInput(
			emailText: emailTextfield.rx.text.orEmpty.distinctUntilChanged(),
			passwordText: passwordTextfield.rx.text.orEmpty.distinctUntilChanged(),
			repeatedPasswordText: repeatPasswordTextfield.rx.text.orEmpty.distinctUntilChanged(),
			signUpButtonPressed: ControlEvent(
				events: signUpButton.rx.tap.map { [emailTextfield, passwordTextfield] _ in
					(emailTextfield.text!, passwordTextfield.text!)
				}
			)
		)
		
		let output = presenter.transform(input)
		
		output.isSignUpButtonEnabled
			.drive { [weak self] in self?.switchSignUpButtonEnabledState(to: $0) }
			.disposed(by: disposeBag)
		
		output.shouldShowPasswordNotEqualLabel
			.map(!)
			.drive(passwordsNotEqualLabel.rx.isHidden)
			.disposed(by: disposeBag)
		
		output.isFetchingData
			.drive(activityIndicatorView.rx.isAnimating)
			.disposed(by: disposeBag)
		
		output.occurredError
			.compactMap { $0 }
			.map { $0.localizedDescription }
			.drive { [weak self] in self?.showAlert(with: $0) }
			.disposed(by: disposeBag)
	}
	
	private func switchSignUpButtonEnabledState(to isEnabled: Bool) {
		signUpButton.isEnabled = isEnabled
		signUpButton.backgroundColor = isEnabled ? Assets.Colors.action.color : Assets.Colors.iron.color.withAlphaComponent(0.5)
	}
	
	private func showAlert(with message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Sign up"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.tintColor = Assets.Colors.action.color
		navigationController?.navigationBar.standardAppearance = .largeClear
	}
}
