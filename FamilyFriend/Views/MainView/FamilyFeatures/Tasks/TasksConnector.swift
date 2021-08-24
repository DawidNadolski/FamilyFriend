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
	
	private weak var tasksViewController: TasksViewController!
	
	init(service: FamilyFriendAPI = FamilyFriendService()) {
		self.service = service
	}
	
	func connect() -> UIViewController {
		let presenter = TasksPresenter(context: .init(tasksViewRoutes: self, service: service))
		let tasksViewController = TasksViewController(presenter: presenter)
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
				connector.service.saveTask(task: task)
				connector.tasksViewController.dismiss(animated: true)
			}
			
			let onCancel: Binder<Void> = Binder(connector) { connector, _ in				
				connector.tasksViewController.dismiss(animated: true)
			}
			
			let presenter = AddTaskPresenter(context: .init(onAddTask: onAddTask, onCancel: onCancel))
			let viewController = AddTaskViewController(presenter: presenter)
			let modal = DraggableModal(embeddedViewController: viewController)
			
			connector.present(viewController: modal)
		}
	}
	
	var toCompleteTask: Binder<Task?> {
		Binder(self) { connector, task in
			guard let task = task else {
				return
			}
			
			let onYes: Binder<Void> = Binder(connector) { connector, task in
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
