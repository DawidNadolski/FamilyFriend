//
//  ShoppingListViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 05/08/2021.
//

import RxSwift
import RxCocoa

final class ShoppingListViewController: UIViewController {
	
	private let presenter: ShoppingListPresenting
	private let shoppingList: ShoppingList
	
	private let tableView = UITableView()
	private let addComponentBarButton = UIBarButtonItem(systemItem: .add)
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)
	private let selectedComponent = BehaviorSubject<ShoppingListComponent?>(value: nil)
	private let deletedComponent = BehaviorSubject<ShoppingListComponent?>(value: nil)
	private let disposeBag = DisposeBag()
	
	private var components = [ShoppingListComponent]()
	
	init(presenter: ShoppingListPresenting, shoppingList: ShoppingList) {
		self.presenter = presenter
		self.shoppingList = shoppingList
		
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
		tableView.register(ComponentCell.self)
		tableView.backgroundColor = Assets.Colors.backgroundWarm.color
		tableView.separatorStyle = .none
	}
	
	private func setupBindings() {
		let input = ShoppingListPresenterInput(
			addComponentButtonPressed: addComponentBarButton.rx.tap,
			componentSelected: ControlEvent(events: selectedComponent),
			componentDeleted: ControlEvent(events: deletedComponent)
		)
		
		let output = presenter.transform(input: input)
		
		output.fetchedComponents
			.drive { [weak self] fetchedComponents in
				self?.components = fetchedComponents
				self?.tableView.reloadData()
			}
			.disposed(by: disposeBag)

		output.isFetchingData
			.drive(activityIndicatorView.rx.isAnimating)
			.disposed(by: disposeBag)
	}
	
	private func setupNavigationBar() {
		navigationItem.rightBarButtonItem = addComponentBarButton
		navigationItem.title = shoppingList.name
		navigationController?.isNavigationBarHidden = false
	}
}

extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		components.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as ComponentCell
		let component = components[indexPath.row]
		
		cell.update(with: component)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let component = components[indexPath.row]
		selectedComponent.onNext(component)
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == UITableViewCell.EditingStyle.delete {
			let removedComponent = components.remove(at: indexPath.row)
			deletedComponent.onNext(removedComponent)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
}
