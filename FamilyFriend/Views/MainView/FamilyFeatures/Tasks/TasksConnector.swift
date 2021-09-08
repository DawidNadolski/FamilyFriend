//
//  TasksConnector.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 16/08/2021.
//

import RxSwift
import RxCocoa

protocol TasksConnecting: Connecting { }

protocol TasksViewRoutes {
	var toAddTask: Binder<Void> { get }
	var toCompleteTask: Binder<Task?> { get }
}

final class TasksConnector: TasksConnecting {
	
	private let service: FamilyFriendAPI
	private let family: Family
	private let member: Member
	
	private weak var tasksViewController: TasksViewController!
	
	private let addedTaskSubject = BehaviorSubject<Task?>(value: nil)
	private let completedTaskSubject = BehaviorSubject<Task?>(value: nil)
	
	init(service: FamilyFriendAPI = FamilyFriendService(), family: Family, member: Member) {
		self.service = service
		self.family = family
		self.member = member
	}
	
	func connect() -> UIViewController {
		let presenter = TasksPresenter(context: .init(tasksViewRoutes: self, service: service, member: member, family: family))
		let tasksViewController = TasksViewController(
			presenter: presenter,
			member: member,
			addedTask: addedTaskSubject,
			completedTask: completedTaskSubject
		)
		self.tasksViewController = tasksViewController
		return tasksViewController
	}
	
	private func present(viewController: UIViewController, completion: @escaping () -> Void = {}) {
		tasksViewController.present(viewController, animated: true, completion: completion)
	}
}

extension TasksConnector: TasksViewRoutes {
	
	var toAddTask: Binder<Void> {
		Binder(self) { connector, _ in
			let onAddTask: Binder<Task> = Binder(connector) { connector, task in
				connector.addedTaskSubject.onNext(task)
				connector.service.saveTask(task)
				connector.tasksViewController.dismiss(animated: true)
			}
			
			let onCancel: Binder<Void> = Binder(connector) { connector, _ in				
				connector.tasksViewController.dismiss(animated: true)
			}
			
			let presenter = AddTaskPresenter(
				context: .init(
					onAddTask: onAddTask,
					onCancel: onCancel,
					service: FamilyFriendService(),
					family: connector.family
				)
			)
			let viewController = AddTaskViewController(presenter: presenter)
			let modal = DraggableModal(embeddedViewController: viewController)
			
			connector.present(viewController: modal)
		}
	}
	
	var toCompleteTask: Binder<Task?> {
		Binder(self) { connector, task in
			guard let task = task, !task.completed else {
				return
			}
			
			let onYes: Binder<Void> = Binder(connector) { connector, _ in
				connector.completedTaskSubject.onNext(task)
				connector.service.completeTask(task)
				connector.tasksViewController.dismiss(animated: true)
			}
			
			let onNo: Binder<Void> = Binder(connector) { connector, _ in
				connector.tasksViewController.dismiss(animated: true)
			}
			
			let presenter = ConfirmActionPresenter(context: .init(onYes: onYes, onNo: onNo))
			let viewController = ConfirmActionViewController(
				presenter: presenter,
				title: "Did you complete the task?",
				yesButtonTitle: "Yes",
				noButtonTitle: "No"
			)
			viewController.modalPresentationStyle = .overCurrentContext
			viewController.modalTransitionStyle = .crossDissolve
			
			connector.present(viewController: viewController)
		}
	}
}
