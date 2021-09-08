//
//  ConfirmActionViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 24/08/2021.
//

import RxSwift
import RxCocoa

final class ConfirmActionViewController: UIViewController {
	
	private let presenter: ConfirmActionPresenting

	private let containerView = TileView()
	private let disposeBag = DisposeBag()
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = Assets.Colors.textPrimary.color
		label.font = FontFamily.SFProText.bold.font(size: 20.0)
		return label
	}()
		
	private let yesButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		return button
	}()
	
	private let noButton: UIButton = {
		let button = makeRoundedSecondaryButton()
		return button
	}()

	init(presenter: ConfirmActionPresenting, title: String, yesButtonTitle: String, noButtonTitle: String) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		setupUI(title: title, yesButtonTitle: yesButtonTitle, noButtonTitle: noButtonTitle)
		setupBindings()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI(title: String, yesButtonTitle: String, noButtonTitle: String) {
		view.backgroundColor = UIColor.black.withAlphaComponent(0.35)

		view.addSubview(containerView)
		containerView.snp.makeConstraints { make in
			make.left.right.equalToSuperview().inset(28.0)
			make.centerY.equalToSuperview()
		}

		containerView.addSubview(titleLabel)
		titleLabel.text = title
		titleLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(16.0)
			make.left.right.equalToSuperview()
		}

		containerView.addSubview(yesButton)
		yesButton.setTitle(yesButtonTitle, for: .normal)
		yesButton.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(32.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.height.equalTo(48.0)
			make.centerX.equalToSuperview()
		}

		containerView.addSubview(noButton)
		noButton.setTitle(noButtonTitle, for: .normal)
		noButton.snp.makeConstraints { make in
			make.top.equalTo(yesButton.snp.bottom).offset(8.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.height.equalTo(48.0)
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().inset(32.0)
		}
	}

	private func setupBindings() {
		let input = ConfirmActionInput(
			onYesButtonTapped: yesButton.rx.tap,
			onNoButtonTapped: noButton.rx.tap
		)
		
		presenter.transform(input: input)
	}
}
