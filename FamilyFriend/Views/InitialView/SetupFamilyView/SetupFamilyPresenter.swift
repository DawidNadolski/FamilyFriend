//
//  SetupFamilyPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import RxSwift
import RxCocoa

protocol SetupFamilyPresenting {
	func transform(_ input: SetupFamilyPresenterInput)
}

struct SetupFamilyPresenterInput {
	var joinFamilyButtonPressed: ControlEvent<Void>
	var createFamilyButtonPressed: ControlEvent<Void>
}

final class SetupFamilyPresenter: SetupFamilyPresenting {
	
	struct Context {
		let setupFamilyViewRoutes: SetupFamilyViewRoutes
	}
	
	private let context: Context
	
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(_ input: SetupFamilyPresenterInput) {
		input.joinFamilyButtonPressed
			.asDriver()
			.drive(context.setupFamilyViewRoutes.toJoinFamily)
			.disposed(by: disposeBag)
		
		input.createFamilyButtonPressed
			.asDriver()
			.drive(context.setupFamilyViewRoutes.toCreateFamily)
			.disposed(by: disposeBag)
	}
}
