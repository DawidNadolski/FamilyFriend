//
//  MainConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 23/07/2021.
//

import UIKit
import RxCocoa

protocol MainComponentsConnecting: Connecting {
	func connectFamilySummary() -> UIViewController
	func connectFamilyFeatures() -> UIViewController
}

protocol FamilySummaryViewRoutes {
	var toSettings: Binder<Void> { get }
	var toMemberDetails: Binder<Void> { get }
}

protocol FamilyFeaturesViewRoutes {
	var toMembersFeature: Binder<Void> { get }
	var toRankingFeature: Binder<Void> { get }
	var toShoppingListsFeature: Binder<Void> { get }
	var toTasksFeature: Binder<Void> { get }
}

final class MainConnector: MainComponentsConnecting {
	
	private let family: Family
	private let member: Member
	private let rootRoutes: RootRoutes
	
	private weak var mainViewController: MainViewController!
	
	init(family: Family, member: Member, rootRoutes: RootRoutes) {
		self.family = family
		self.member = member
		self.rootRoutes = rootRoutes
	}
	
	func connect() -> UIViewController {
		let mainViewController = MainViewController(mainComponentsConnector: self)
		self.mainViewController = mainViewController
		return mainViewController
	}
	
	func connectFamilySummary() -> UIViewController {
		let familySummaryConnector = FamilySummaryConnector(
			family: family,
			member: member,
			familySummaryViewRoutes: self,
			rootRoutes: rootRoutes
		)
		return familySummaryConnector.connect()
	}
	
	func connectFamilyFeatures() -> UIViewController {
		let familyFeaturesConnector = FamilyFeaturesConnector(familyFeaturesViewRoutes: self)
		return familyFeaturesConnector.connect()
	}
	
	private func present(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		mainViewController.present(viewController, animated: true, completion: completion)
	}
	
	private func push(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		guard let navigationController = mainViewController.navigationController else {
			assertionFailure("Couldn't find navigation controller")
			return
		}
		
		navigationController.pushViewController(viewController, animated: true)
	}
}

extension MainConnector: FamilySummaryViewRoutes {
	
	var toSettings: Binder<Void> {
		Binder(self) { connector, _ in
			let onCancel: Binder<Void> = Binder(connector) { connector, _ in
				connector.mainViewController.dismiss(animated: true)
			}
			let settingsConnector = FamilySettingsConnector(
				family: connector.family,
				member: connector.member,
				rootRoutes: connector.rootRoutes,
				onCancel: onCancel
			)
			let viewController = settingsConnector.connect()
			viewController.modalPresentationStyle = .overCurrentContext
			viewController.modalTransitionStyle = .crossDissolve
			connector.present(viewController: viewController)
		}
	}

	var toMemberDetails: Binder<Void> {
		Binder(self) { connector, _ in
			let member = connector.member
			let presenter = MemberDetailsPresenter(context: .init(member: member, service: FamilyFriendService()))
			connector.push(viewController: MemberDetailsViewController(presenter: presenter, member: member))
		}
	}
}

extension MainConnector: FamilyFeaturesViewRoutes {
	
	var toMembersFeature: Binder<Void> {
		return Binder(self) { connector, _ in
			let membersConnector = MembersConnector(family: connector.family)
			connector.push(viewController: membersConnector.connect())
		}
	}
	
	var toRankingFeature: Binder<Void> {
		return Binder(self) { connector, _ in
			let presenter = RankingPresenter(context: .init(service: FamilyFriendService(), family: connector.family))
			connector.push(viewController: RankingViewController(presenter: presenter))
		}
	}
	
	var toShoppingListsFeature: Binder<Void> {
		return Binder(self) { connector, _ in
			let shoppingListsConnector = ShoppingListsConnector(family: connector.family)
			connector.push(viewController: shoppingListsConnector.connect())
		}
	}
	
	var toTasksFeature: Binder<Void> {
		return Binder(self) { connector, _ in
			let tasksConnector = TasksConnector(family: connector.family, member: connector.member)
			connector.push(viewController: tasksConnector.connect())
		}
	}
}
