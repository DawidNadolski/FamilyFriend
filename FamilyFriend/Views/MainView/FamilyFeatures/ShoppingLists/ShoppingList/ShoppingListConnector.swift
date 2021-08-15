//
//  ShoppingListConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 15/08/2021.
//

import RxCocoa
import RxSwift

protocol ShoppingListConnecting: Connecting { }

protocol ShoppingListViewRoutes {
	var toAddComponent: Binder<Void> { get }
}

final class ShoppingListConnector: ShoppingListConnecting {
	
	private let shoppingList: ShoppingList
	
	private weak var shoppingListViewController: ShoppingListViewController!
	
	init(shoppingList: ShoppingList) {
		self.shoppingList = shoppingList
	}
	
	func connect() -> UIViewController {
		let presenter = ShoppingListPresenter(
			context: .init(shoppingListViewRoutes: self)
		)
		let shoppingListViewController = ShoppingListViewController(presenter: presenter, shoppingList: shoppingList)
		self.shoppingListViewController = shoppingListViewController
		return shoppingListViewController
	}
	
	private func present(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		shoppingListViewController.present(viewController, animated: true, completion: completion)
	}
	
	private func push(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		guard let navigationController = shoppingListViewController.navigationController else {
			assertionFailure("Couldn't find navigation controller")
			return
		}
		
		navigationController.pushViewController(viewController, animated: true)
	}
}

extension ShoppingListConnector: ShoppingListViewRoutes {
	
	var toAddComponent: Binder<Void> {
		Binder(self) { connector, _ in
			let onNo: Binder<Void> = Binder(connector) { connector, _ in
				connector.shoppingListViewController.dismiss(animated: true)
			}
			
			let onYes: Binder<String> = Binder(connector) { connector, listName in
				connector.shoppingListViewController.dismiss(animated: true)
			}
			
			let presenter = AddItemPresenter(context: .init(onYes: onYes, onNo: onNo))
			let viewController = AddItemViewController(
				presenter: presenter,
				title: "Enter component name",
				yesButtonTitle: "Add",
				noButtonTitle: "Cancel"
			)
			viewController.modalPresentationStyle = .overCurrentContext
			viewController.modalTransitionStyle = .crossDissolve
			
			connector.present(viewController: viewController)
		}
	}
}
