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
	let taskAdded: ControlEvent<Task?>
	let taskCompleted: ControlEvent<Task?>
	let taskDeleted: ControlEvent<Task?>
}

struct TasksPresenterOutput {
	let fetchedTasks: Driver<[Task]>
	let isFetchingData: Driver<Bool>
}

final class TasksPresenter: TasksPresenting {
	
	struct Context {
		let tasksViewRoutes: TasksViewRoutes
		let service: FamilyFriendAPI
		let member: Member
		let family: Family
	}
	
	private let context: Context
	
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let tasksSubject = BehaviorRelay<[Task]>(value: [])
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
		
		input.taskAdded
			.asDriverOnErrorJustComplete()
			.compactMap { $0 }
			.drive(addTaskBinder)
			.disposed(by: disposeBag)
		
		input.taskCompleted
			.asDriverOnErrorJustComplete()
			.compactMap { $0 }
			.drive(completeTaskBinder)
			.disposed(by: disposeBag)
		
		let output = TasksPresenterOutput(
			fetchedTasks: tasksSubject.asDriverOnErrorJustComplete(),
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private var addTaskBinder: Binder<Task> {
		Binder(self) { presenter, addedTask in
			var tasks = presenter.tasksSubject.value
			tasks.append(addedTask)
			presenter.tasksSubject.accept(tasks)
		}
	}
	
	private var completeTaskBinder: Binder<Task> {
		Binder(self) { presenter, taskToComplete in
			var tasks = presenter.tasksSubject.value
			var completedTask = taskToComplete
			completedTask.completed = true
			guard let indexOfCompletedTask = tasks.firstIndex(of: taskToComplete) else {
				print("Couldn't find task to complete")
				return
			}
			tasks.remove(at: indexOfCompletedTask)
			tasks.insert(completedTask, at: indexOfCompletedTask)
			presenter.tasksSubject.accept(tasks)
		}
	}
	
	private func fetchTasks() {
		isFetchingDataSubject.onNext(true)
		Observable.combineLatest(
			context.service.getMembers().map { $0.map { Member(from: $0) } },
			context.service.getTasks().map { $0.map { Task(from: $0) } }
		)
		.asDriverOnErrorJustComplete()
		.drive(familyTasksBinder)
		.disposed(by: disposeBag)
	}
	
	private var familyTasksBinder: Binder<([Member], [Task])> {
		Binder(self) { presenter, items in
			let (members, tasks) = items
			let familyMembers = members.filter { $0.familyId == presenter.context.family.id }
			let membersIds = familyMembers.map { $0.id }
			var familyTasks = [Task]()
			for task in tasks {
				if membersIds.contains(task.assignedMemberId) {
					familyTasks.append(task)
				}
			}
			presenter.tasksSubject.accept(familyTasks)
		}
	}
}
