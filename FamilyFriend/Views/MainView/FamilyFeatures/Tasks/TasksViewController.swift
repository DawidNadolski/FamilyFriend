//
//  TasksViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 11/07/2021.
//

import RxCocoa

final class TasksViewController: UIViewController {
	
	private let presenter: TasksPresenting
	
	private let tableView = UITableView()
	private let member: Member = .init(id: 1, name: "Dawid Nadolski", avatarURL: nil)
	private let addTaskBarButton = UIBarButtonItem(systemItem: .add)
	
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
			addTaskButtonPressed: addTaskBarButton.rx.tap.asControlEvent()
		)
		
		presenter.transform(input: input)
	}
	
	private func setupNavigationBar() {
		navigationItem.rightBarButtonItem = addTaskBarButton
		navigationItem.title = "Tasks"
		navigationController?.isNavigationBarHidden = false
	}
	
	private func fetchData() {
		let url = URL(string: "http://localhost:8080/tasks")!
		
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard let data = data else {
				print(error?.localizedDescription ?? "Unknown error.")
				return
			}
			
			let decoder = JSONDecoder()
			
			if let tasks = try? decoder.decode([Task].self, from: data) {
				DispatchQueue.main.async {
					self.tasks = tasks
					self.tableView.reloadData()
					print("Loaded \(tasks.count) tasks.")
				}
			} else {
				print("Unable to parse JSON response.")
			}
		}
		.resume()
	}
}

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		tasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as TaskCell
		let task = tasks[indexPath.row]
		
		cell.update(with: task, for: member)
		
		return cell
	}
}
