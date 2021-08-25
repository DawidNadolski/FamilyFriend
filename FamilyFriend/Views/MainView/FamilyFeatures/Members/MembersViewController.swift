//
//  MembersViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 11/07/2021.
//

import RxSwift
import RxCocoa

final class MembersViewController: UIViewController {
	
	private let presenter: MembersPresenting
	
	private let tableView = UITableView()
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)
	private let selectedMember = BehaviorRelay<Member?>(value: nil)
	private let disposeBag = DisposeBag()
		
	private var members = [Member]()
	
	init(presenter: MembersPresenting) {
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
		
		view.addSubview(activityIndicatorView)
		activityIndicatorView.center = view.center
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8.0)
			make.left.bottom.right.equalToSuperview()
		}
	}
	
	private func setupBindings() {
		let input = MembersPresenterInput(
			memberSelected: ControlEvent(events: selectedMember)
		)
		
		let output = presenter.transform(input: input)
		
		output.fetchedMembers
			.drive { [weak self] fetchedMembers in
				self?.members = fetchedMembers
				self?.tableView.reloadData()
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
		tableView.register(MemberCell.self)
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Members"
		navigationController?.isNavigationBarHidden = false
	}
}

extension MembersViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		members.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as MemberCell
		let member = members[indexPath.row]
		
		cell.update(with: member)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let member = members[indexPath.row]
		selectedMember.accept(member)
	}
}
