//
//  SignInViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 14/08/2021.
//

import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {
	
	private let presenter: SignInPresenting
	
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)
	private let disposeBag = DisposeBag()

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
		let button = makeRoundedPrimaryButton()
		button.setTitle("Sign in", for: .normal)
		return button
	}()

	init(presenter: SignInPresenting) {
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

		view.addSubview(signInButton)
		signInButton.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(passwordTextfield.snp.bottom).offset(48.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(activityIndicatorView)
		activityIndicatorView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(signInButton.snp.bottom).offset(64.0)
		}
	}
	
	private func setupBindings() {
		let input = SignInPresenterInput(
			emailText: emailTextfield.rx.text.orEmpty.distinctUntilChanged(),
			passwordText: passwordTextfield.rx.text.orEmpty.distinctUntilChanged(),
			signInButtonPressed: ControlEvent(
				events: signInButton.rx.tap.map { [emailTextfield, passwordTextfield] _ in
					(emailTextfield.text!, passwordTextfield.text!)
				}
			)
		)
		
		let output = presenter.transform(input)
		
		output.isSignInButtonEnabled
			.drive { [weak self] in self?.switchSignInButtonEnabledState(to: $0) }
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
	
	private func switchSignInButtonEnabledState(to isEnabled: Bool) {
		signInButton.isEnabled = isEnabled
		signInButton.backgroundColor = isEnabled ? Assets.Colors.action.color : Assets.Colors.iron.color.withAlphaComponent(0.5)
	}
	
	private func showAlert(with message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Sign in"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.tintColor = Assets.Colors.action.color
		navigationController?.navigationBar.standardAppearance = .largeClear
	}
}
