//
//  InitialConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 14/08/2021.
//

import RxCocoa

protocol InitialConnecting: Connecting { }

protocol InitialViewRoutes {
	var toSignIn: Binder<Void> { get }
	var toSignUp: Binder<Void> { get }
}

final class InitialConnector: InitialConnecting {
	
	private let rootRoutes: RootRoutes
	
	private weak var initialViewController: InitialViewController!
	
	init(rootRoutes: RootRoutes) {
		self.rootRoutes = rootRoutes
	}
	
	func connect() -> UIViewController {
		let presenter = InitialPresenter(
			context: .init(initialViewRoutes: self)
		)
		let initialViewController = InitialViewController(presenter: presenter)
		self.initialViewController = initialViewController
		return initialViewController
	}
	
	private func push(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		guard let navigationController = initialViewController.navigationController else {
			assertionFailure("Couldn't find navigation controller")
			return
		}
		
		navigationController.pushViewController(viewController, animated: true)
	}
}

extension InitialConnector: InitialViewRoutes {
	
	var toSignIn: Binder<Void> {
		Binder(self) { connector, _ in
			let signInConnector = SignInConnector(rootRoutes: connector.rootRoutes)
			connector.push(viewController: signInConnector.connect())
		}
	}
	
	var toSignUp: Binder<Void> {
		Binder(self) { connector, _ in
			let signUpConnector = SignUpConnector(rootRoutes: connector.rootRoutes)
			connector.push(viewController: signUpConnector.connect())
		}
	}
}
