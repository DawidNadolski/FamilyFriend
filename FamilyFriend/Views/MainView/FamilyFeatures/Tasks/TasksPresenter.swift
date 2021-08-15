//
//  TasksPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 03/08/2021.
//

import RxSwift
import RxCocoa

protocol TasksPresenting {
	func transform(input: TasksPresenterInput)
}

struct TasksPresenterInput {
	let addTaskButtonPressed: ControlEvent<Void>
}

struct TasksPresenterOutput {
	
}

final class TasksPresenter: TasksPresenting {
	
	struct Context {
		let toAddTask: Binder<Void>
	}
	
	private let context: Context
	
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: TasksPresenterInput) {
		input.addTaskButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(context.toAddTask)
			.disposed(by: disposeBag)
	}
}
