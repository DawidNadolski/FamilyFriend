//
//  TasksViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 11/07/2021.
//

import RxSwift
import RxCocoa

final class TasksViewController: UIViewController {
	
	private let presenter: TasksPresenting
	private let member: Member
	
	private weak var addedTask: BehaviorSubject<Task?>!
	private weak var completedTask: BehaviorSubject<Task?>!
	
	private let tableView = UITableView()
	private let addTaskBarButton = UIBarButtonItem(systemItem: .add)
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)
	private let selectedTask = BehaviorSubject<Task?>(value: nil)
	private let deletedTask = BehaviorSubject<Task?>(value: nil)
	private let disposeBag = DisposeBag()
	
	private var tasks: [Task] = []
	
	init(presenter: TasksPresenting, member: Member, addedTask: BehaviorSubject<Task?>, completedTask: BehaviorSubject<Task?>) {
		self.presenter = presenter
		self.member = member
		self.addedTask = addedTask
		self.completedTask = completedTask
		super.init(nibName: nil, bundle: nil)
		setupUI()
		setupTableView()
		setupBindings()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBar()
	}
	
	private func setupUI() {
		view.backgroundColor = Assets.Colors.backgroundWarm.color
		
		view.addSubview(activityIndicatorView)
		activityIndicatorView.center = view.center
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8.0)
			make.left.bottom.right.equalToSuperview()
		}
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(TaskCell.self)
		tableView.backgroundColor = Assets.Colors.backgroundWarm.color
		tableView.separatorStyle = .none
	}
	
	private func setupBindings() {
		let input = TasksPresenterInput(
			addTaskButtonPressed: addTaskBarButton.rx.tap.asControlEvent(),
			taskSelected: ControlEvent(events: selectedTask),
			taskAdded: ControlEvent(events: addedTask),
			taskCompleted: ControlEvent(events: completedTask),
			taskDeleted: ControlEvent(events: deletedTask)
		)
		
		let output = presenter.transform(input: input)
		
		output.fetchedTasks
			.drive { [weak self] fetchedTasks in
				self?.tasks = fetchedTasks
				self?.tableView.reloadData()
			}
			.disposed(by: disposeBag)

		output.isFetchingData
			.drive(activityIndicatorView.rx.isAnimating)
			.disposed(by: disposeBag)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Tasks"
		navigationItem.rightBarButtonItem = addTaskBarButton
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.standardAppearance = .standard
		navigationController?.navigationBar.tintColor = Assets.Colors.action.color.withAlphaComponent(0.7)
	}
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as TaskCell
		let task = tasks[indexPath.row]
		
		cell.update(with: task, isTaskAssignedToYou: task.assignedMemberId == member.id)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let task = tasks[indexPath.row]
		if task.assignedMemberId == member.id {
			selectedTask.onNext(task)
		}
	}
		
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let removedTask = tasks.remove(at: indexPath.row)
			deletedTask.onNext(removedTask)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
	
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
		let taskToRemove = tasks[indexPath.row]
		
		if taskToRemove.completed {
			return .none
		}
		
		return .delete
	}
}
