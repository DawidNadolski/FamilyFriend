//
//  AddTaskPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 03/08/2021.
//

import RxSwift
import RxCocoa

protocol AddTaskPresenting {
	func transform(input: AddTaskPresenterInput) -> AddTaskPresenterOutput
}

struct AddTaskPresenterInput {
	let nameText: Driver<String?>
	let xpPoints: Driver<Int?>
	let assignedMember: Driver<Member?>
	let addButtonPressed: ControlEvent<Task>
	let cancelButtonPressed: ControlEvent<Void>
}

struct AddTaskPresenterOutput {
	let isAddButtonEnabled: Driver<Bool>
}

final class AddTaskPresenter: AddTaskPresenting {
	
	struct Context {
		let onAddTask: Binder<Task>
		let onCancel: Binder<Void>
	}
	
	private let context: Context
	
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: AddTaskPresenterInput) -> AddTaskPresenterOutput {
		input.addButtonPressed
			.asDriver()
			.drive(context.onAddTask)
			.disposed(by: disposeBag)
		
		input.cancelButtonPressed
			.asDriver()
			.drive(context.onCancel)
			.disposed(by: disposeBag)
		
		let isAddButtonEnabled = Observable
			.combineLatest(input.nameText.asObservable(), input.xpPoints.asObservable())
			.map { name, xpPoints -> Bool in
				guard
					let name = name,
					let _ = xpPoints
				else {
					return false
				}
				return !name.isEmpty
			}
			.asDriverOnErrorJustComplete()
		
		return AddTaskPresenterOutput(isAddButtonEnabled: isAddButtonEnabled)
	}
}
