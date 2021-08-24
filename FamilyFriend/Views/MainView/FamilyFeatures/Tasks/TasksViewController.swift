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
	
	private let tableView = UITableView()
	private let addTaskBarButton = UIBarButtonItem(systemItem: .add)
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)
	private let selectedTask = BehaviorSubject<Task?>(value: nil)
	private let disposeBag = DisposeBag()
	
	private var tasks: [Task] = []
	
	init(presenter: TasksPresenting) {
		self.presenter = presenter
		
		super.init(nibName: nil, bundle: nil)
		
		setupUI()
		setupTableView()
		setupBindings()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		fetchData()
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
			taskSelected: ControlEvent(events: selectedTask)
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
		navigationItem.rightBarButtonItem = addTaskBarButton
		navigationItem.title = "Tasks"
		navigationController?.isNavigationBarHidden = false
	}
	
	private func fetchData() {
		
		let service = FamilyFriendService()
		
		service.getTasks()
			.asDriverOnErrorJustComplete()
			.drive { tasks in
				self.tasks = tasks
				self.tableView.reloadData()
			}
			.disposed(by: disposeBag)
	}
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as TaskCell
		let task = tasks[indexPath.row]
		
		cell.update(with: task)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let task = tasks[indexPath.row]
		
		if !task.completed {
			selectedTask.onNext(task)
		}
	}
}
