//
//  FamilySettingsConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 29/08/2021.
//

import RxCocoa

protocol FamilySettingsConnecting: Connecting { }

protocol FamilySettingsViewRoutes {
	var toFamilyInfo: Binder<Void> { get }
	var toAbandonFamily: Binder<Void> { get }
}

final class FamilySettingsConnector: FamilySettingsConnecting {
	
	private let family: Family
	private let member: Member
	private let service: FamilyFriendAPI
	private let rootRoutes: RootRoutes
	private let onCancel: Binder<Void>
	
	private weak var familySettingsViewController: FamilySettingsViewController!
	
	init(family: Family, member: Member, service: FamilyFriendAPI = FamilyFriendService(), rootRoutes: RootRoutes, onCancel: Binder<Void>) {
		self.family = family
		self.member = member
		self.service = service
		self.rootRoutes = rootRoutes
		self.onCancel = onCancel
	}
	
	func connect() -> UIViewController {
		let presenter = FamilySettingsPresenter(
			context: .init(
				member: member,
				service: service,
				familySettingsViewRoutes: self,
				rootRoutes: rootRoutes,
				onCancel: onCancel)
		)
		let viewController = FamilySettingsViewController(presenter: presenter)
		familySettingsViewController = viewController
		return viewController
	}
	
	private func present(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		familySettingsViewController.present(viewController, animated: true, completion: completion)
	}
}

extension FamilySettingsConnector: FamilySettingsViewRoutes {
	
	var toFamilyInfo: Binder<Void> {
		Binder(self) { connector, _ in			
			let onCancel: Binder<Void> = Binder(connector) { connector, _ in
				connector.familySettingsViewController.dismiss(animated: true)
			}
						
			let presenter = FamilyInfoPresenter(context: .init(onCancel: onCancel, family: connector.family))
			let viewController = FamilyInfoViewController(presenter: presenter)
			viewController.modalPresentationStyle = .overFullScreen
			viewController.modalTransitionStyle = .crossDissolve
			connector.present(viewController: viewController)
		}
	}
	
	var toAbandonFamily: Binder<Void> {
		Binder(self) { connector, _ in
//			let encoder = JSONEncoder()
//			let defaults = UserDefaults.standard
//			let family = Family(id: UUID(), name: "The Smiths", password: "Presence2021")
//			let member = Member(id: UUID(), familyId: family.id, name: "Dawid Nadolski")
//			if let encodedFamily = try? encoder.encode(family) {
//				defaults.set(encodedFamily, forKey: "savedFamily")
//			}
//			if let encodedMember = try? encoder.encode(member) {
//				defaults.set(encodedMember, forKey: "savedMember")
//			}
			connector.familySettingsViewController.dismiss(animated: true)
		}
	}
}
