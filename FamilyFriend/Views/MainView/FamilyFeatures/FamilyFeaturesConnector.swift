//
//  FamilyFeaturesConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 29/08/2021.
//

import RxCocoa

protocol FamilyFeaturesConnecting: Connecting { }

final class FamilyFeaturesConnector: FamilyFeaturesConnecting {
	
	private let familyFeaturesViewRoutes: FamilyFeaturesViewRoutes
	
	init(familyFeaturesViewRoutes: FamilyFeaturesViewRoutes) {
		self.familyFeaturesViewRoutes = familyFeaturesViewRoutes
	}
	
	func connect() -> UIViewController {
		let presenter = FamilyFeaturesPresenter(context: .init(familyFeaturesViewRoutes: familyFeaturesViewRoutes))
		return FamilyFeaturesViewController(presenter: presenter)
	}
}
