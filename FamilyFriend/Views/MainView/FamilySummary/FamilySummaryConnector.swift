//
//  FamilySummaryConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 29/08/2021.
//

import RxCocoa

protocol FamilySummaryConnecting: Connecting { }

final class FamilySummaryConnector: FamilySummaryConnecting {
	
	private let family: Family
	private let member: Member
	private let familySummaryViewRoutes: FamilySummaryViewRoutes
	private let rootRoutes: RootRoutes
	
	private weak var familySummaryViewController: FamilySummaryViewController!
	
	init(family: Family, member: Member, familySummaryViewRoutes: FamilySummaryViewRoutes, rootRoutes: RootRoutes) {
		self.family = family
		self.member = member
		self.familySummaryViewRoutes = familySummaryViewRoutes
		self.rootRoutes = rootRoutes
	}
	
	func connect() -> UIViewController {
		let presenter = FamilySummaryPresenter(context: .init(familySummaryViewRoutes: familySummaryViewRoutes))
		let viewController = FamilySummaryViewController(presenter: presenter, family: family, member: member)
		familySummaryViewController = viewController
		return viewController
	}
	
	private func present(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		familySummaryViewController.present(viewController, animated: true, completion: completion)
	}
	
	private func push(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		guard let navigationController = familySummaryViewController.navigationController else {
			assertionFailure("Couldn't find navigation controller")
			return
		}
		
		navigationController.pushViewController(viewController, animated: true)
	}
}
