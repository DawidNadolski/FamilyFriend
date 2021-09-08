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
	private let session: UserSession
	private let rootRoutes: RootRoutes
	
	private weak var setupFamilyViewController: SetupFamilyViewController!
	
	init(service: FamilyFriendAPI = FamilyFriendService(), session: UserSession, rootRoutes: RootRoutes) {
		self.service = service
		self.session = session
		self.rootRoutes = rootRoutes
	}
	
	func connect() -> UIViewController {
		let presenter = SetupFamilyPresenter(
			context: .init(
				setupFamilyViewRoutes: self,
				userSession: session
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
				context: .init(service: FamilyFriendService(), rootRoutes: connector.rootRoutes)
			)
			connector.push(viewController: JoinFamilyViewController(presenter: presenter))
		}
	}
	
	var toCreateFamily: Binder<Void> {
		Binder(self) { connector, _ in
			let presenter = CreateFamilyPresenter(
				context: .init(service: FamilyFriendService(), session: connector.session, rootRoutes: connector.rootRoutes)
			)
			connector.push(viewController: CreateFamilyViewController(presenter: presenter))
		}
	}
}
