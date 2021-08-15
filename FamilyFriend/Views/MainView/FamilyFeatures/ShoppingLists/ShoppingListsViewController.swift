//
//  ShoppingListViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 11/07/2021.
//

import RxCocoa

final class ShoppingListsViewController: UIViewController {
	
	// TODO: Get rid of mock data
	private let lists: [ShoppingList] = [
		.init(name: "Groceries"),
		.init(name: "Clothings"),
		.init(name: "Fruits")
	]
	
	private let tableView = UITableView()
	private let selectedList = BehaviorRelay<ShoppingList?>(value: nil)
	private let addListBarButton = UIBarButtonItem(systemItem: .add)
	
	private let presenter: ShoppingListsPresenting
	
	init(presenter: ShoppingListsPresenting) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		
		setupUI()
		setupBindings()
		setupTableView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(_ animated: Bool) {
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
	
	private func setupBindings() {
		let input = ShoppingListsPresentingInput(
			listSelected: ControlEvent(events: selectedList),
			addListPressed: addListBarButton.rx.tap
		)
		
		presenter.transform(input: input)
	}
	
	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.backgroundColor = Assets.Colors.backgroundWarm.color
		tableView.register(ShoppingListCell.self)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Shopping lists"
		navigationItem.rightBarButtonItem = addListBarButton
		navigationController?.isNavigationBarHidden = false
	}
}

extension ShoppingListsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		lists.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as ShoppingListCell
		let list = lists[indexPath.row]
		
		cell.update(with: list)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let list = lists[indexPath.row]
		selectedList.accept(list)
	}
}
