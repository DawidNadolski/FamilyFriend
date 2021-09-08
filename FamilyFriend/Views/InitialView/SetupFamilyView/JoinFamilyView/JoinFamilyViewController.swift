//
//  JoinFamilyViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import RxSwift
import RxCocoa

final class JoinFamilyViewController: UIViewController {
	
	private let presenter: JoinFamilyPresenting
	
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)
	private let disposeBag = DisposeBag()
	
	private let memberNameTextField: UITextField = {
		let textfield = makeTextField()
		textfield.placeholder = "Enter your name"
		return textfield
	}()

	private let familyIdTextField: UITextField = {
		let textfield = makeTextField()
		textfield.placeholder = "Family ID"
		return textfield
	}()

	private let familyPasswordTextfield: UITextField = {
		let textfield = makeTextField()
		textfield.placeholder = "Family password"
		textfield.isSecureTextEntry = true
		return textfield
	}()

	private let joinFamilyButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		button.setTitle("Join family", for: .normal)
		return button
	}()

	init(presenter: JoinFamilyPresenting) {
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
		
		view.addSubview(memberNameTextField)
		memberNameTextField.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
		}

		view.addSubview(familyIdTextField)
		familyIdTextField.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(memberNameTextField.snp.bottom).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
		}

		view.addSubview(familyPasswordTextfield)
		familyPasswordTextfield.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(familyIdTextField.snp.bottom).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
		}

		view.addSubview(joinFamilyButton)
		joinFamilyButton.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(familyPasswordTextfield.snp.bottom).offset(48.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(activityIndicatorView)
		activityIndicatorView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(joinFamilyButton.snp.bottom).offset(64.0)
		}
	}
	
	private func setupBindings() {
		let input = JoinFamilyPresenterInput(
			memberNameText: memberNameTextField.rx.text.orEmpty.distinctUntilChanged(),
			familyIdText: familyIdTextField.rx.text.orEmpty.distinctUntilChanged(),
			familyPasswordText: familyPasswordTextfield.rx.text.orEmpty.distinctUntilChanged(),
			joinFamilyButtonPressed: ControlEvent(
				events: joinFamilyButton.rx.tap.map { [memberNameTextField ,familyIdTextField, familyPasswordTextfield] in
					(memberNameTextField.text! ,familyIdTextField.text!, familyPasswordTextfield.text!)
				}
			)
		)
		
		let output = presenter.transform(input)
		
		output.isFetchingData
			.drive(activityIndicatorView.rx.isAnimating)
			.disposed(by: disposeBag)
		
		output.isJoinFamilyButtonEnabled
			.drive { [weak self] in self?.switchJoinFamilyButtonEnabledState(to: $0) }
			.disposed(by: disposeBag)
		
		output.occurredError
			.compactMap { $0 }
			.map { $0.localizedDescription }
			.drive { [weak self] in self?.showAlert(with: $0) }
			.disposed(by: disposeBag)
	}
	
	private func switchJoinFamilyButtonEnabledState(to isEnabled: Bool) {
		joinFamilyButton.isEnabled = isEnabled
		joinFamilyButton.backgroundColor = isEnabled ? Assets.Colors.action.color : Assets.Colors.iron.color.withAlphaComponent(0.5)
	}
	
	private func showAlert(with message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "Continue", style: .cancel, handler: nil)
		alert.addAction(action)
		present(alert, animated: true, completion: nil)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Joining family"
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.standardAppearance = .largeClear
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.tintColor = Assets.Colors.action.color
	}
}
