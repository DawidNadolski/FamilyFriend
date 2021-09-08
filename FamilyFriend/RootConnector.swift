//
//  RootConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 14/08/2021.
//

import RxCocoa

protocol RootConnecting: Connecting {
	func connectInitialView() -> UIViewController
	func connectMainView() -> UIViewController
}

protocol RootRoutes {
	var onFinishConfiguringFamily: Binder<(Family, Member)> { get }
	var onAbandonFamily: Binder<Void> { get }
	var onLogout: Binder<Void> { get }
}

final class RootConnector: RootConnecting {
	
	private let window: UIWindow
	
	private let userDefaults = UserDefaults.standard
		
	init(window: UIWindow) {
		self.window = window
	}
	
	func connect() -> UIViewController {
		if isUserLoggedIn() {
			return connectMainView()
		} else {
			return connectInitialView()
		}
	}
	
	func connectInitialView() -> UIViewController {
		UINavigationController(rootViewController: InitialConnector(rootRoutes: self).connect())
	}
	
	func connectMainView() -> UIViewController {
		let decoder = JSONDecoder()
		guard
			let savedMember = userDefaults.object(forKey: "savedMember") as? Data,
			let savedFamily = userDefaults.object(forKey: "savedFamily") as? Data,
			let loadedMember = try? decoder.decode(Member.self, from: savedMember),
			let loadedFamily = try? decoder.decode(Family.self, from: savedFamily)
		else {
			fatalError("Couldn't load saved member")
		}
		
		let service = FamilyFriendService()
		service.saveMember(loadedMember)
		service.saveFamily(loadedFamily)
		
		let viewController = UINavigationController(
			rootViewController: MainConnector(family: loadedFamily, member: loadedMember, rootRoutes: self).connect()
		)
		return viewController
	}
	
	private func isUserLoggedIn() -> Bool {
		guard
			let _ = userDefaults.value(forKey: "savedMember"),
			let _ = userDefaults.value(forKey: "savedFamily")
		else {
			return false
		}
		
		let isUserLoggedIn = userDefaults.bool(forKey: "isUserLoggedIn")
		
		return isUserLoggedIn
	}
	
	private func logOut() {
		userDefaults.setValue(nil, forKey: "member")
		userDefaults.setValue(nil, forKey: "family")
		userDefaults.setValue(false, forKey: "isUserLoggedIn")
		
		showInitialView()
	}
	
	private func showInitialView() {
		changeWindowRootViewController(to: connectInitialView())
	}
	
	private func showMainView() {
		changeWindowRootViewController(to: connectMainView())
	}
	
	private func changeWindowRootViewController(to viewController: UIViewController) {
		window.rootViewController = viewController
		UIView.transition(
			with: window,
			duration: 0.4,
			options: .transitionCrossDissolve,
			animations: nil
		)
	}
	
	private func saveUserData(family: Family, member: Member) {
		let encoder = JSONEncoder()
		guard
			let encodedFamily = try? encoder.encode(family),
			let encodedMember = try? encoder.encode(member)
		else  {
			fatalError("Couldn't save user data")
		}
		let defaults = UserDefaults.standard
		defaults.set(encodedFamily, forKey: "savedFamily")
		defaults.set(encodedMember, forKey: "savedMember")
		defaults.set(true, forKey: "isUserLoggedIn")
	}
	
	private func deleteUserData() {
		let defaults = UserDefaults.standard
		defaults.set(nil, forKey: "savedFamily")
		defaults.set(nil, forKey: "savedMember")
		defaults.set(nil, forKey: "joinedDate")
	}
}

extension RootConnector: RootRoutes {
	
	var onFinishConfiguringFamily: Binder<(Family, Member)> {
		Binder(self) { connector, userData in
			let (family, member) = userData
			connector.saveUserData(family: family, member: member)
			connector.showMainView()
		}
	}
	
	var onAbandonFamily: Binder<Void> {
		Binder(self) { connector, _ in
			connector.deleteUserData()
			connector.showInitialView()
		}
	}
	
	var onLogout: Binder<Void> {
		Binder(self) { connector, _ in
			connector.showInitialView()
		}
	}
}
