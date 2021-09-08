//
//  FamilySettingsPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 29/08/2021.
//

import RxSwift
import RxCocoa

protocol FamilySettingsPresenting {
	func transform(_ input: FamilySettingsPresenterInput)
}

struct FamilySettingsPresenterInput {
	let familyInfoButtonPressed: ControlEvent<Void>
	let abandonFamilyButtonPressed: ControlEvent<Void>
	let logoutButtonPressed: ControlEvent<Void>
	let cancelButtonPressed: ControlEvent<Void>
}

final class FamilySettingsPresenter: FamilySettingsPresenting {
	
	struct Context {
		let member: Member
		let service: FamilyFriendAPI
		let familySettingsViewRoutes: FamilySettingsViewRoutes
		let rootRoutes: RootRoutes
		let onCancel: Binder<Void>
	}
	
	private let context: Context
	
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(_ input: FamilySettingsPresenterInput) {
		input.familyInfoButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(context.familySettingsViewRoutes.toFamilyInfo)
			.disposed(by: disposeBag)
		
		input.abandonFamilyButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(abandonFamilyBinder)
			.disposed(by: disposeBag)
		
		input.logoutButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(context.rootRoutes.onLogout)
			.disposed(by: disposeBag)
		
		input.cancelButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(context.onCancel)
			.disposed(by: disposeBag)
	}
	
	private var abandonFamilyBinder: Binder<Void> {
		Binder(self) { presenter, _ in
			presenter.context.service.deleteMember(presenter.context.member)
			presenter.context.rootRoutes.onAbandonFamily.onNext(())
		}
	}
}
