//
//  MembersConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/07/2021.
//

import UIKit

protocol MembersComponentsConnecting: Connecting {
	func connectMemberDetails() -> UIViewController
}

final class MembersConnector: MembersComponentsConnecting {
	
	func connect() -> UIViewController {
		UIViewController()
	}
	
	func connectMemberDetails() -> UIViewController {
		UIViewController()
	}
}
