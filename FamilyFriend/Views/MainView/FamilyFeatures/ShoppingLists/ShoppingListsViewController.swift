//
//  ShoppingListViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 11/07/2021.
//

import RxSwift
import RxCocoa

final class ShoppingListsViewController: UIViewController {
		
	private let presenter: ShoppingListsPresenting
	private weak var addedList: BehaviorSubject<ShoppingList?>!
	
	private let tableView = UITableView()
	private let addListBarButton = UIBarButtonItem(systemItem: .add)
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)
	private let selectedList = BehaviorSubject<ShoppingList?>(value: nil)
	private let deletedList = BehaviorSubject<ShoppingList?>(value: nil)
	private let disposeBag = DisposeBag()
	
	private var lists: [ShoppingList] = []
	
	init(presenter: ShoppingListsPresenting, addedList: BehaviorSubject<ShoppingList?>) {
		self.presenter = presenter
		self.addedList = addedList
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
		
		view.addSubview(activityIndicatorView)
		activityIndicatorView.center = view.center
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8.0)
			make.left.bottom.right.equalToSuperview()
		}
	}
	
	private func setupBindings() {
		let input = ShoppingListsPresentingInput(
			addListPressed: addListBarButton.rx.tap,
			listSelected: ControlEvent(events: selectedList),
			listDeleted: ControlEvent(events: deletedList),
			listAdded: ControlEvent(events: addedList)
		)
		
		let output = presenter.transform(input: input)
		
		output.fetchedLists
			.drive { [weak self, tableView] fetchedLists in
				self?.lists = fetchedLists
				tableView.reloadData()
			}
			.disposed(by: disposeBag)

		output.isFetchingData
			.drive(activityIndicatorView.rx.isAnimating)
			.disposed(by: disposeBag)
	}
	
	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.backgroundColor = Assets.Colors.backgroundWarm.color
		tableView.register(ShoppingListCell.self)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Lists"
		navigationItem.rightBarButtonItem = addListBarButton
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.standardAppearance = .standard
		navigationController?.navigationBar.tintColor = Assets.Colors.action.color.withAlphaComponent(0.7)
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
		selectedList.onNext(list)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let removedList = lists.remove(at: indexPath.row)
			deletedList.onNext(removedList)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
}
