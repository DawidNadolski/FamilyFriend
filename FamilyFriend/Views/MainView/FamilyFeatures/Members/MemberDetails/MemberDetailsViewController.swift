//
//  MemberDetailsViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 31/07/2021.
//

import RxSwift

final class MemberDetailsViewController: UIViewController {
	
	private let presenter: MemberDetailsPresenting
	private let member: Member
	
	private let tableView = UITableView()
	private let disposeBag = DisposeBag()
	
	private var memberActiveTasks = [Task]()
	
	init(presenter: MemberDetailsPresenting, member: Member) {
		self.presenter = presenter
		self.member = member
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
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8.0)
			make.left.bottom.right.equalToSuperview()
		}
	}
	
	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.backgroundColor = Assets.Colors.backgroundWarm.color
		tableView.register(MemberTaskCell.self)
	}
	
	private func setupBindings() {
		let output = presenter.transform()
		
		output.memberActiveTasks
			.drive { [weak self] fetchedTasks in
				self?.memberActiveTasks = fetchedTasks
				self?.tableView.reloadData()
			}
			.disposed(by: disposeBag)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = member.name
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.standardAppearance = .standard
		navigationController?.navigationBar.tintColor = Assets.Colors.action.color.withAlphaComponent(0.7)
	}
}

extension MemberDetailsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		memberActiveTasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as MemberTaskCell
		let task = memberActiveTasks[indexPath.row]
		
		cell.update(with: task)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerTitle = memberActiveTasks == [] ? "" : "Active tasks"
		return HeaderLabelView(header: headerTitle, backgroundColor: Assets.Colors.backgroundWarm.color)
	}
}
