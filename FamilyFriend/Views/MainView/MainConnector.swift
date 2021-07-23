//
//  MainConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 23/07/2021.
//

import UIKit

protocol MainComponentsConnecting {
	func connectFamilyFeatures() -> UIViewController
	func connectFamilySummary() -> UIViewController
}

final class MainConnector: MainComponentsConnecting {
	
	func connect() -> UIViewController {
		return MainViewController(mainComponentsConnector: self)
	}
	
	func connectFamilySummary() -> UIViewController {
		FamilySummaryViewController()
	}
	
	func connectFamilyFeatures() -> UIViewController {
		let presenter = FamilyFeaturesPresenter(context: .init())
		return FamilyFeaturesViewController(presenter: presenter)
	}
}
