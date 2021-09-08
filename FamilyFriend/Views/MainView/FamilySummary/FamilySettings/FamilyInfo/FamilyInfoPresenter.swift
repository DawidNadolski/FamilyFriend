//
//  FamilyInfoPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 29/08/2021.
//

import RxSwift
import RxCocoa

protocol FamilyInfoPresenting {
	func transform(_ input: FamilyInfoPresenterInput)
}

struct FamilyInfoPresenterInput {
	let copyFamilyIdButtonPressed: ControlEvent<Void>
	let copyPasswordButtonPressed: ControlEvent<Void>
	let cancelButtonPressed: ControlEvent<Void>
}

final class FamilyInfoPresenter: FamilyInfoPresenting {
	
	struct Context {
		let onCancel: Binder<Void>
		let family: Family
	}
	
	private let context: Context
	
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(_ input: FamilyInfoPresenterInput) {
		input.cancelButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(context.onCancel)
			.disposed(by: disposeBag)
		
		input.copyFamilyIdButtonPressed
			.asDriverOnErrorJustComplete()
			.drive { [context] _ in
				UIPasteboard.general.string = context.family.id.uuidString
			}
			.disposed(by: disposeBag)

		input.copyPasswordButtonPressed
			.asDriverOnErrorJustComplete()
			.drive { [context] _ in
				UIPasteboard.general.string = context.family.password
			}
			.disposed(by: disposeBag)
	}
}
