//
//  RootConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 14/08/2021.
//

import UIKit

protocol RootConnecting: Connecting {
	func connectInitialView() -> UIViewController
	func connectMainView() -> UIViewController
}

final class RootConnector: RootConnecting {
	
	struct Context {
		
	}
	
	private let context: Context
	
	init(context: Context) {
		self.context = context
	}
	
	func connect() -> UIViewController {
		// TODO: Check propperly whether user is logged in
		let isUserLoggedIn = true
		if isUserLoggedIn {
			return connectMainView()
		} else {
			return connectInitialView()
		}
	}
	
	func connectInitialView() -> UIViewController {
		InitialConnector().connect()
	}
	
	func connectMainView() -> UIViewController {
		MainConnector().connect()
	}
}
