//
//  MemberDetailsViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 31/07/2021.
//

import UIKit

final class MemberDetailsViewController: UIViewController {
	
	private let containerView = TileView()
	private let tableView = UITableView()
	
	// TODO: Replace with real data
	private let member = Member(id: 1, name: "Dawid Nadolski", avatarURL: nil)
	private let memberActiveTasks: [Task] = [
		.init(taskID: 1, name: "Zmywanie naczyń", description: "", xpPoints: 30),
		.init(taskID: 2, name: "Odkurzanie", description: "", xpPoints: 45),
		.init(taskID: 3, name: "Umycie kurzy", description: "", xpPoints: 60)
	]
	
	private let avatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.backgroundColor = Assets.Colors.backgroundCool.color
		imageView.layer.cornerRadius = 12.0
		imageView.image = UIImage(systemName: "photo")
		imageView.tintColor = Assets.Colors.backgroundWarm.color
		return imageView
	}()
	
	private let joinedDateLabel: UILabel = {
		let label = UILabel()
		label.textColor = Assets.Colors.textPrimary.color
		label.font = FontFamily.SFProText.regular.font(size: 10.0)
		label.text = "Joined on 24th April 2021"
		return label
	}()
	
	init() {
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
		
		view.addSubview(containerView)
		containerView.backgroundColor = .white
		containerView.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(avatarImageView)
		avatarImageView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(8.0)
			make.size.equalTo(94.0)
			make.centerX.equalToSuperview()
		}
		
		containerView.addSubview(joinedDateLabel)
		joinedDateLabel.snp.makeConstraints { make in
			make.top.equalTo(avatarImageView.snp.bottom).offset(4.0)
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.top.equalTo(containerView.snp.bottom).offset(20.0)
			make.left.bottom.right.equalToSuperview()
		}
	}
	
	private func setupTableView() {
		tableView.dataSource = self
		tableView.delegate = self
		tableView.separatorStyle = .none
		tableView.backgroundColor = Assets.Colors.backgroundWarm.color
		tableView.register(TaskCell.self)
	}
	
	private func setupBindings() {
		
	}
	
	private func setupNavigationBar() {
		navigationItem.title = member.name
	}
}

extension MemberDetailsViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		memberActiveTasks.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as TaskCell
		let task = memberActiveTasks[indexPath.row]
		
		cell.update(with: task, for: member)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		HeaderLabelView(header: "Active tasks", backgroundColor: Assets.Colors.backgroundWarm.color)
	}
}
