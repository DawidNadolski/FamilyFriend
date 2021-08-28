//
//  SetupFamilyViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import UIKit

final class SetupFamilyViewController: UIViewController {
	
	private let presenter: SetupFamilyPresenting
	
	private let containerView = UIView()
	
	private let joinFamilyButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		button.setTitle("Join family", for: .normal)
		return button
	}()

	private let createFamilyButton: UIButton = {
		let button = makeRoundedSecondaryButton()
		button.setTitle("Create family", for: .normal)
		return button
	}()
	
	init(presenter: SetupFamilyPresenting) {
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
		
		view.addSubview(containerView)
		containerView.backgroundColor = Assets.Colors.backgroundWarm.color
		containerView.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(joinFamilyButton)
		joinFamilyButton.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.left.right.equalToSuperview()
		}
		
		containerView.addSubview(createFamilyButton)
		createFamilyButton.snp.makeConstraints { make in
			make.height.equalTo(48.0)
			make.top.equalTo(joinFamilyButton.snp.bottom).offset(48.0)
			make.left.right.bottom.equalToSuperview()
		}
	}
	
	private func setupBindings() {
		let input = SetupFamilyPresenterInput(
			joinFamilyButtonPressed: joinFamilyButton.rx.tap,
			createFamilyButtonPressed: createFamilyButton.rx.tap
		)
		
		presenter.transform(input)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Setup family"
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.standardAppearance = .largeClear
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationController?.navigationBar.tintColor = Assets.Colors.action.color
	}
}
