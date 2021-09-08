//
//  FamilyInfoViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 29/08/2021.
//

import RxSwift

final class FamilyInfoViewController: UIViewController {
	
	private let presenter: FamilyInfoPresenting

	private let containerView = TileView()
	private let disposeBag = DisposeBag()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Family info"
		label.textAlignment = .center
		label.textColor = Assets.Colors.textPrimary.color
		label.font = FontFamily.SFProText.bold.font(size: 20.0)
		return label
	}()
	
	private let copyFamilyIdButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		button.setTitle("Copy family ID", for: .normal)
		return button
	}()
	
	private let copyPasswordButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		button.setTitle("Copy password", for: .normal)
		return button
	}()
	
	private let cancelButton: UIButton = {
		let button = makeRoundedSecondaryButton()
		button.setTitle("Back", for: .normal)
		return button
	}()
	
	init(presenter: FamilyInfoPresenting) {
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
			make.top.equalToSuperview().offset(42.0)
			make.left.right.equalToSuperview()
		}

		containerView.addSubview(copyFamilyIdButton)
		copyFamilyIdButton.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(32.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.height.equalTo(48.0)
			make.centerX.equalToSuperview()
		}

		containerView.addSubview(copyPasswordButton)
		copyPasswordButton.snp.makeConstraints { make in
			make.top.equalTo(copyFamilyIdButton.snp.bottom).offset(8.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.height.equalTo(48.0)
			make.centerX.equalToSuperview()
		}
		
		containerView.addSubview(cancelButton)
		cancelButton.snp.makeConstraints { make in
			make.top.equalTo(copyPasswordButton.snp.bottom).offset(24.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.height.equalTo(48.0)
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().inset(60.0)
		}
	}

	private func setupBindings() {
		let input = FamilyInfoPresenterInput(
			copyFamilyIdButtonPressed: copyFamilyIdButton.rx.tap,
			copyPasswordButtonPressed: copyPasswordButton.rx.tap,
			cancelButtonPressed: cancelButton.rx.tap
		)
		presenter.transform(input)
	}
}
