//
//  SetupFamilyConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import RxCocoa

protocol SetupFamilyConnecting: Connecting { }

protocol SetupFamilyViewRoutes {
	var toJoinFamily: Binder<Void> { get }
	var toCreateFamily: Binder<Void> { get }
}

final class SetupFamilyConnector: SetupFamilyConnecting {
	
	private let service: FamilyFriendAPI
	
	private weak var setupFamilyViewController: SetupFamilyViewController!
	
	init(service: FamilyFriendAPI = FamilyFriendService()) {
		self.service = service
	}
	
	func connect() -> UIViewController {
		let presenter = SetupFamilyPresenter(
			context: .init(
				setupFamilyViewRoutes: self
			)
		)
		let viewController = SetupFamilyViewController(presenter: presenter)
		setupFamilyViewController = viewController
		return viewController
	}
	
	private func push(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		guard let navigationController = setupFamilyViewController.navigationController else {
			assertionFailure("Couldn't find navigation controller")
			return
		}
		
		navigationController.pushViewController(viewController, animated: true)
	}
}

extension SetupFamilyConnector: SetupFamilyViewRoutes {
	
	var toJoinFamily: Binder<Void> {
		Binder(self) { connector, _ in
			let presenter = JoinFamilyPresenter(
				context: .init(service: FamilyFriendService())
			)
			connector.push(viewController: JoinFamilyViewController(presenter: presenter))
		}
	}
	
	var toCreateFamily: Binder<Void> {
		Binder(self) { connector, _ in
			let presenter = CreateFamilyPresenter(
				context: .init(service: FamilyFriendService())
			)
			connector.push(viewController: CreateFamilyViewController(presenter: presenter))
		}
	}
}
