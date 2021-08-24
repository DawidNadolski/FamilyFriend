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
				connector.service.saveTask(task)
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
}
