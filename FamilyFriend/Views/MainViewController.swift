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
		return stackView
	}()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
	}
	
	private func setupUI() {
		view.backgroundColor = .lightGray
		
		
	}
}

