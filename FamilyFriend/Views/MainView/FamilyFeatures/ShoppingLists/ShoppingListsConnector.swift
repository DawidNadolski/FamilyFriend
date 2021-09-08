//
//  ShoppingListsConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 15/08/2021.
//

import RxSwift
import RxCocoa

protocol ShoppingListsConnecting: Connecting { }

protocol ShoppingListsViewRoutes {
	var toAddList: Binder<Void> { get }
	var toShoppingList: Binder<ShoppingList> { get }
}

final class ShoppingListsConnector: ShoppingListsConnecting {
	
	private let service: FamilyFriendAPI
	private let family: Family
	
	private weak var shoppingListsViewController: ShoppingListsViewController!
	
	private let addedListSubject = BehaviorSubject<ShoppingList?>(value: nil)
	
	init(service: FamilyFriendAPI = FamilyFriendService(), family: Family) {
		self.service = service
		self.family = family
	}
	
	func connect() -> UIViewController {
		let presenter = ShoppingListsPresenter(
			context: .init(
				shoppingListsViewRoutes: self,
				service: service,
				family: family)
		)
		let shoppingListsViewController = ShoppingListsViewController(presenter: presenter, addedList: addedListSubject)
		self.shoppingListsViewController = shoppingListsViewController
		return shoppingListsViewController
	}
	
	private func present(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		shoppingListsViewController.present(viewController, animated: true, completion: completion)
	}
	
	private func push(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		guard let navigationController = shoppingListsViewController.navigationController else {
			assertionFailure("Couldn't find navigation controller")
			return
		}
		
		navigationController.pushViewController(viewController, animated: true)
	}
}

extension ShoppingListsConnector: ShoppingListsViewRoutes {
	
	var toAddList: Binder<Void> {
		Binder(self) { connector, _ in
			let onNo: Binder<Void> = Binder(connector) { connector, _ in
				connector.shoppingListsViewController.dismiss(animated: true)
			}
			
			let onYes: Binder<String> = Binder(connector) { connector, listName in
				let shoppingList = ShoppingList(id: UUID(), familyId: connector.family.id, name: listName)
				connector.addedListSubject.onNext(shoppingList)
				connector.service.saveShoppingList(shoppingList)
				connector.shoppingListsViewController.dismiss(animated: true)
			}
			
			let presenter = AddItemPresenter(context: .init(onYes: onYes, onNo: onNo))
			let viewController = AddItemViewController(
				presenter: presenter,
				title: "Enter list name",
				yesButtonTitle: "Add",
				noButtonTitle: "Cancel"
			)
			viewController.modalPresentationStyle = .overCurrentContext
			viewController.modalTransitionStyle = .crossDissolve
			
			connector.present(viewController: viewController)
		}
	}
	
	var toShoppingList: Binder<ShoppingList> {
		Binder(self) { connector, list in
			let shoppingListConnector = ShoppingListConnector(shoppingList: list, service: connector.service)
			connector.push(viewController: shoppingListConnector.connect())
		}
	}
}
