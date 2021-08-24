//
//  ConfirmActionPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 24/08/2021.
//

import RxSwift
import RxCocoa

protocol ConfirmActionPresenting {
	func transform(input: ConfirmActionInput)
}

struct ConfirmActionInput {
	let onYesButtonTapped: ControlEvent<Void>
	let onNoButtonTapped: ControlEvent<Void>
}

final class ConfirmActionPresenter: ConfirmActionPresenting {
	
	struct Context {
		let onYes: Binder<Void>
		let onNo: Binder<Void>
	}
	
	private let context: Context
	
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: ConfirmActionInput) {
		input.onNoButtonTapped
			.asDriverOnErrorJustComplete()
			.drive(context.onNo)
			.disposed(by: disposeBag)
		
		input.onYesButtonTapped
			.asDriverOnErrorJustComplete()
			.drive(context.onYes)
			.disposed(by: disposeBag)
	}
}
