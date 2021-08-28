//
//  SignUpConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import RxCocoa

protocol SignUpConnecting: Connecting { }

protocol SignUpViewRoutes {
	var toSetupFamily: Binder<UserSession> { get }
}

final class SignUpConnector: SignUpConnecting {
	
	private let service: FamilyFriendAPI
	
	private weak var signUpViewController: SignUpViewController!
	
	init(service: FamilyFriendAPI) {
		self.service = service
	}
	
	func connect() -> UIViewController {
		let presenter = SignUpPresenter(
			context: .init(
				service: service,
				signUpViewRoutes: self
			)
		)
		let viewController = SignUpViewController(presenter: presenter)
		signUpViewController = viewController
		return viewController
	}
	
	private func push(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		guard let navigationController = signUpViewController.navigationController else {
			assertionFailure("Couldn't find navigation controller")
			return
		}
		
		navigationController.pushViewController(viewController, animated: true)
	}
}

extension SignUpConnector: SignUpViewRoutes {
	
	var toSetupFamily: Binder<UserSession> {
		Binder(self) { connector, _ in
			let setupFamilyConnector = SetupFamilyConnector(service: connector.service)
			connector.push(viewController: setupFamilyConnector.connect())
		}
	}
}
