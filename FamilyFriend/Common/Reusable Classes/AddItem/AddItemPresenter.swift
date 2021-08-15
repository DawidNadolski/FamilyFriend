//
//  AddItemPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 15/08/2021.
//

import RxSwift
import RxCocoa

protocol AddItemPresenting {
	func transform(input: AddItemPresenterInput) -> AddItemPresenterOutput
}

struct AddItemPresenterInput {
	let textFieldText: Driver<String?>
	let onNoButtonTapped: ControlEvent<Void>
	let onYesButtonTapped: ControlEvent<String>
}

struct AddItemPresenterOutput {
	let isYesButtonEnabled: Driver<Bool>
}

final class AddItemPresenter: AddItemPresenting {
	
	struct Context {
		let onYes: Binder<String>
		let onNo: Binder<Void>
	}
	
	private let context: Context
	
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: AddItemPresenterInput) -> AddItemPresenterOutput {
		input.onNoButtonTapped
			.asDriverOnErrorJustComplete()
			.drive(context.onNo)
			.disposed(by: disposeBag)
		
		input.onYesButtonTapped
			.asDriverOnErrorJustComplete()
			.drive(context.onYes)
			.disposed(by: disposeBag)
		
		let isYesButtonEnabled = input.textFieldText
			.map { text -> Bool in
				guard let text = text else {
					return false
				}
				return !text.isEmpty
			}
		
		let output = AddItemPresenterOutput(
			isYesButtonEnabled: isYesButtonEnabled
		)
		
		return output
	}
}
