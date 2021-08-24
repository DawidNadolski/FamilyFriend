//
//  TasksPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 03/08/2021.
//

import RxSwift
import RxCocoa

protocol TasksPresenting {
	func transform(input: TasksPresenterInput) -> TasksPresenterOutput
}

struct TasksPresenterInput {
	let addTaskButtonPressed: ControlEvent<Void>
	let taskSelected: ControlEvent<Task?>
}

struct TasksPresenterOutput {
	let fetchedTasks: Driver<[Task]>
	let isFetchingData: Driver<Bool>
}

final class TasksPresenter: TasksPresenting {
	
	struct Context {
		let tasksViewRoutes: TasksViewRoutes
		let service: FamilyFriendAPI
	}
	
	private let context: Context
	
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let tasksSubject = BehaviorSubject<[Task]>(value: [])
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: TasksPresenterInput) -> TasksPresenterOutput {
		fetchTasks()
		
		input.addTaskButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(context.tasksViewRoutes.toAddTask)
			.disposed(by: disposeBag)
		
		input.taskSelected
			.asDriverOnErrorJustComplete()
			.drive(context.tasksViewRoutes.toCompleteTask)
			.disposed(by: disposeBag)
		
		let output = TasksPresenterOutput(
			fetchedTasks: tasksSubject.asDriverOnErrorJustComplete(),
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private func fetchTasks() {
		isFetchingDataSubject.onNext(true)
		context.service
			.getTasks()
			.asDriverOnErrorJustComplete()
			.drive { [tasksSubject] tasks in
				tasksSubject.onNext(tasks)
			} onCompleted: { [isFetchingDataSubject] in
				isFetchingDataSubject.onNext(false)
			}
			.disposed(by: disposeBag)
	}
}
