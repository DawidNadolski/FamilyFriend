//
//  SignInConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import RxCocoa

protocol SignInConnecting: Connecting { }

protocol SignInViewRoutes {
	var toSetupFamily: Binder<Void> { get }
}

final class SignInConnector: SignInConnecting {
	
	private let service: FamilyFriendAPI
	
	private weak var signInViewController: SignInViewController!
	
	init(service: FamilyFriendAPI = FamilyFriendService()) {
		self.service = service
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
	
	private func present(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		signInViewController.present(viewController, animated: true, completion: completion)
	}
}

extension SignInConnector: SignInViewRoutes {
	
	var toSetupFamily: Binder<Void> {
		Binder(self) { connector, _ in
			
		}
	}
	
	var toMainView: Binder<Void> {
		Binder(self) { connector, _ in
			
		}
	}
}
