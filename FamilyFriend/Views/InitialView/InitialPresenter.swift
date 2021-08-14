//
//  InitialPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 14/08/2021.
//

import RxCocoa
import RxSwift

protocol InitialPresenting {
	func transform(input: InitialPresenterInput)
}

struct InitialPresenterInput {
	let signInButtonPressed: ControlEvent<Void>
	let signUpButtonPressed: ControlEvent<Void>
}

final class InitialPresenter: InitialPresenting {
	
	struct Context {
		let initialViewRoutes: InitialViewRoutes
	}
	
	private let context: Context
	
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: InitialPresenterInput) {
		input.signInButtonPressed
			.asDriver()
			.debug()
			.drive(context.initialViewRoutes.toSignIn)
			.disposed(by: disposeBag)
		
		input.signUpButtonPressed
			.asDriver()
			.debug()
			.drive(onNext: { [context] _ in
				print("Co jest kurwa")
				context.initialViewRoutes.toSignUp.onNext(())
			})
			.disposed(by: disposeBag)
	}
}
