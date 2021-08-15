//
//  MainConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 23/07/2021.
//

import UIKit
import RxCocoa

protocol MainComponentsConnecting: Connecting {
	func connectFamilyFeatures() -> UIViewController
	func connectFamilySummary() -> UIViewController
}

protocol MainViewRoutes {
	var toMembersFeature: Binder<Void> { get }
	var toRankingFeature: Binder<Void> { get }
	var toShoppingListsFeature: Binder<Void> { get }
	var toTasksFeature: Binder<Void> { get }
}

final class MainConnector: MainComponentsConnecting {
	
	private weak var mainViewController: MainViewController!
	
	func connect() -> UIViewController {
		let mainViewController = MainViewController(mainComponentsConnector: self)
		self.mainViewController = mainViewController
		return mainViewController
	}
	
	func connectFamilySummary() -> UIViewController {
		let presenter = FamilySummaryPresenter(context: .init())
		return FamilySummaryViewController(presenter: presenter)
	}
	
	func connectFamilyFeatures() -> UIViewController {
		let presenter = FamilyFeaturesPresenter(
			context: .init(mainViewRoutes: self)
		)
		return FamilyFeaturesViewController(presenter: presenter)
	}
	
	private func push(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		guard let navigationController = mainViewController.navigationController else {
			assertionFailure("Couldn't find navigation controller")
			return
		}
		
		navigationController.pushViewController(viewController, animated: true)
	}
}

extension MainConnector: MainViewRoutes {
	var toMembersFeature: Binder<Void> {
		return Binder(self) { connector, _ in
			let presenter = MembersPresenter(
				context: .init(
					toMemberDetails: Binder(connector) { connector, member in
						let memberDetailsViewController = MemberDetailsViewController()
						connector.push(viewController: memberDetailsViewController)
					}
				)
			)
			let membersViewController = MembersViewController(presenter: presenter)
			connector.push(viewController: membersViewController)
		}
	}
	
	var toRankingFeature: Binder<Void> {
		return Binder(self) { connector, _ in
			
		}
	}
	
	var toShoppingListsFeature: Binder<Void> {
		return Binder(self) { connector, _ in
			let shoppingListsConnector = ShoppingListsConnector()
			connector.push(viewController: shoppingListsConnector.connect())
		}
	}
	
	var toTasksFeature: Binder<Void> {
		return Binder(self) { connector, _ in
			let presenter = TasksPresenter(
				context: .init(
					toAddTask: Binder(connector) { connector, _ in
						let addTaskViewController = AddTaskViewController()
						addTaskViewController.modalPresentationStyle = .overCurrentContext
						addTaskViewController.modalTransitionStyle = .crossDissolve
						let modal = DraggableModal(embeddedViewController: addTaskViewController)
						connector.mainViewController.present(modal, animated: true)
					}
				)
			)
			let tasksViewController = TasksViewController(presenter: presenter)
			connector.push(viewController: tasksViewController)
		}
	}
}
