//
//  MembersConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/07/2021.
//

import RxSwift
import RxCocoa

protocol MembersViewConnecting: Connecting { }

protocol MembersViewRoutes: Connecting {
	var toMemberDetails: Binder<Member> { get }
}

final class MembersConnector: MembersViewConnecting {
	
	private let family: Family
	
	private weak var membersViewController: MembersViewController!
	
	init(family: Family) {
		self.family = family
	}
	
	func connect() -> UIViewController {
		let presenter = MembersPresenter(
			context: .init(
				membersViewRoutes: self,
				service: FamilyFriendService(),
				family: family
			)
		)
		let viewController = MembersViewController(presenter: presenter)
		membersViewController = viewController
		
		return viewController
	}
	
	private func push(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		guard let navigationController = membersViewController.navigationController else {
			assertionFailure("Couldn't find navigation controller")
			return
		}
		
		navigationController.pushViewController(viewController, animated: true)
	}
}

extension MembersConnector: MembersViewRoutes {
	
	var toMemberDetails: Binder<Member> {
		Binder(self) { connector, member in
			let presenter = MemberDetailsPresenter(
				context: .init(
					member: member,
					service: FamilyFriendService()
				)
			)
			let viewController = MemberDetailsViewController(presenter: presenter, member: member)
			connector.push(viewController: viewController)
		}
	}
}
