//
//  MainViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 07/07/2021.
//

import UIKit

class MainViewController: UIViewController {
	
	private let mainComponentsConnector: MainComponentsConnecting
	private let scrollView = UIScrollView()
	
	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.spacing = 32.0
		return stackView
	}()
	
	init(mainComponentsConnector: MainComponentsConnecting) {
		self.mainComponentsConnector = mainComponentsConnector
		
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setupNavigationBar()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		view.backgroundColor = Assets.Colors.backgroundWarm.color
		
		view.addSubview(scrollView)
		
		let familyFeaturesViewController = mainComponentsConnector.connectFamilyFeatures()
		let familySummaryViewController = mainComponentsConnector.connectFamilySummary()
		
		scrollView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16.0)
			make.left.right.equalToSuperview()
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(16.0)
		}
		
		scrollView.addSubview(stackView)
		stackView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
			make.width.equalToSuperview()
		}
		
		stackView.addViewController(familySummaryViewController, parent: self)
		stackView.addViewController(familyFeaturesViewController, parent: self)
	}
	
	private func setupNavigationBar() {
		navigationController?.isNavigationBarHidden = true
	}
}

