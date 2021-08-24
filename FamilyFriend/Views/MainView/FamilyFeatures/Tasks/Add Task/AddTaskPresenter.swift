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
	let nameText: Observable<String>
	let xpPoints: Observable<String>
	let assignedMember: Observable<Member?>
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
	
	private let addButtonEnabledSubject = BehaviorSubject<Bool>(value: false)
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
		
		Observable.combineLatest(
			input.nameText,
			input.xpPoints,
			input.assignedMember
		)
		.asDriverOnErrorJustComplete()
		.drive(validateInputBinder)
		.disposed(by: disposeBag)
		
		return AddTaskPresenterOutput(isAddButtonEnabled: addButtonEnabledSubject.asDriverOnErrorJustComplete())
	}
	
	private var validateInputBinder: Binder<(String, String, Member?)> {
		Binder(self) { presenter, input in
			let (name, xpPoints, member) = input

			guard member != nil, Int(xpPoints) != nil
			else {
				presenter.addButtonEnabledSubject.onNext(false)
				return
			}
			presenter.addButtonEnabledSubject.onNext(name != "")
		}
	}
}
