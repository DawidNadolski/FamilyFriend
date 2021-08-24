//
//  MembersViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 11/07/2021.
//

import UIKit
import RxCocoa

final class MembersViewController: UIViewController {
		
	// TODO: Get rid of mock data
	private let members: [Member] = [
		.init(id: UUID(), name: "Dawid Nadolski", avatarURL: nil),
		.init(id: UUID(), name: "Mateusz Nadolski", avatarURL: nil),
		.init(id: UUID(), name: "Grażyna Nadolska", avatarURL: nil),
		.init(id: UUID(), name: "Grzegorz Nadolski", avatarURL: nil),
		.init(id: UUID(), name: "Agata Nadolska", avatarURL: nil)
	]
	
	private let tableView = UITableView()
	private let selectedMember = BehaviorRelay<Member?>(value: nil)
	
	private let presenter: MembersPresenting
	
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
		
		presenter.transform(input: input)
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
