//
//  SignInConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import RxCocoa

protocol SignInConnecting: Connecting { }

protocol SignInViewRoutes {
	var toSetupFamily: Binder<UserSession> { get }
	var toMainView: Binder<(Family, Member)> { get }
}

final class SignInConnector: SignInConnecting {
	
	private let service: FamilyFriendAPI
	private let rootRoutes: RootRoutes
	
	private weak var signInViewController: SignInViewController!
	
	init(service: FamilyFriendAPI = FamilyFriendService(), rootRoutes: RootRoutes) {
		self.service = service
		self.rootRoutes = rootRoutes
	}
	
	func connect() -> UIViewController {
		let presenter = SignInPresenter(
			context: .init(
				service: service,
				signInViewRoutes: self
			)
		)
		let viewController = SignInViewController(presenter: presenter)
		signInViewController = viewController
		return viewController
	}
	
	private func push(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		guard let navigationController = signInViewController.navigationController else {
			assertionFailure("Couldn't find navigation controller")
			return
		}
		
		navigationController.pushViewController(viewController, animated: true)
	}
}

extension SignInConnector: SignInViewRoutes {
	
	var toSetupFamily: Binder<UserSession> {
		Binder(self) { connector, session in
			let setupFamilyConnector = SetupFamilyConnector(session: session, rootRoutes: connector.rootRoutes)
			connector.push(viewController: setupFamilyConnector.connect())
		}
	}
	
	var toMainView: Binder<(Family, Member)> {
		Binder(self) { connector, familyData in
			let (family, member) = familyData
			connector.rootRoutes.onFinishConfiguringFamily.onNext((family, member))
		}
	}
}
