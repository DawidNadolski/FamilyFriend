//
//  CreateFamilyViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import RxSwift
import RxCocoa

final class CreateFamilyViewController: UIViewController {
	
	private let presenter: CreateFamilyPresenting
	
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)
	private let disposeBag = DisposeBag()

	private let familyNameTextField: UITextField = {
		let textfield = makeTextField()
		textfield.placeholder = "Family name"
		return textfield
	}()
	
	private let familyPasswordTextField: UITextField = {
		let textfield = makeTextField()
		textfield.placeholder = "Set password (at least 8 characters)"
		return textfield
	}()

	private let createFamilyButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		button.setTitle("Create family", for: .normal)
		return button
	}()

	init(presenter: CreateFamilyPresenting) {
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

		view.addSubview(familyNameTextField)
		familyNameTextField.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(familyPasswordTextField)
		familyPasswordTextField.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(familyNameTextField.snp.bottom).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
		}

		view.addSubview(createFamilyButton)
		createFamilyButton.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(familyPasswordTextField.snp.bottom).offset(48.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(activityIndicatorView)
		activityIndicatorView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalTo(createFamilyButton.snp.bottom).offset(64.0)
		}
	}
	
	private func setupBindings() {
		let input = CreateFamilyPresenterInput(
			familyNameText: familyNameTextField.rx.text.orEmpty.distinctUntilChanged(),
			familyPasswordText: familyPasswordTextField.rx.text.orEmpty.distinctUntilChanged(),
			createFamilyButtonPressed: ControlEvent(
				events: createFamilyButton.rx.tap.map { [familyNameTextField, familyPasswordTextField] _ in
					(familyNameTextField.text!, familyPasswordTextField.text!)
				}
			)
		)
		
		let output = presenter.transform(input)
		
		output.isFetchingData
			.drive(activityIndicatorView.rx.isAnimating)
			.disposed(by: disposeBag)
		
		output.isCreateFamilyButtonEnabled
			.drive { [weak self] in self?.switchCreateFamilyButtonEnabledState(to: $0) }
			.disposed(by: disposeBag)
	}
	
	private func switchCreateFamilyButtonEnabledState(to isEnabled: Bool) {
		createFamilyButton.isEnabled = isEnabled
		createFamilyButton.backgroundColor = isEnabled ? Assets.Colors.action.color : Assets.Colors.iron.color.withAlphaComponent(0.5)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Creating family"
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.standardAppearance = .largeClear
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.tintColor = Assets.Colors.action.color
	}
}
