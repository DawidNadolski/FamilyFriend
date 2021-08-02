//
//  HeaderLabelView.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 01/08/2021.
//

import UIKit

final class HeaderLabelView: UIView {

	private let separatorView: UIView = {
		let view = UIView()
		view.backgroundColor = Assets.Colors.backgroundCool.color
		return view
	}()

	private let headerLabel: UILabel = {
		let label = UILabel()
		label.font = FontFamily.SFProText.bold.font(size: 20.0)
		label.textColor = Assets.Colors.textPrimary.color
		return label
	}()

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	init(
		header: String? = nil,
		headerFontSize: CGFloat = 20.0,
		shouldShowTopSeparatorView: Bool = false,
		edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0),
		backgroundColor: UIColor = .clear
	) {
		super.init(frame: .zero)
		headerLabel.text = header
		setupView(
			headerFontSize: headerFontSize,
			shouldShowTopSeparatorView: shouldShowTopSeparatorView,
			edgeInsets: edgeInsets,
			backgroundColor: backgroundColor
		)
	}

	func update(header: String) {
		headerLabel.text = header
	}

	private func setupView(
		headerFontSize: CGFloat,
		shouldShowTopSeparatorView: Bool,
		edgeInsets: UIEdgeInsets,
		backgroundColor: UIColor
	) {
		self.backgroundColor = backgroundColor
		if shouldShowTopSeparatorView {
			addSubview(separatorView)
			separatorView.snp.makeConstraints { make in
				make.height.equalTo(0.5)
				make.top.leading.trailing.equalToSuperview()
			}
		}

		addSubview(headerLabel)
		headerLabel.font = FontFamily.SFProText.bold.font(size: headerFontSize)
		headerLabel.snp.makeConstraints { make in
			make.edges.equalToSuperview().inset(edgeInsets)
		}
	}
}

