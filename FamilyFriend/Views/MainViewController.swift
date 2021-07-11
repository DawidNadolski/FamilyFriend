//
//  MainViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 07/07/2021.
//

import UIKit

class MainViewController: UIViewController {
	
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.spacing = 32.0
		return stackView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		view.backgroundColor = Assets.Colors.backgroundCool.color
		
		view.addSubview(stackView)
		
		let familySummaryViewController = FamilySummaryViewController()
		
		stackView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16.0)
			make.left.right.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16.0)
		}
		
		stackView.addViewController(familySummaryViewController, parent: self)
	}
}

