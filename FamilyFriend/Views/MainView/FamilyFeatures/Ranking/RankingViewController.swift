//
//  RankingViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 11/07/2021.
//

import RxSwift

final class RankingViewController: UIViewController {
	
	private let presenter: RankingPresenting
	
	private let tableView = UITableView()
	private let activityIndicatorView = UIActivityIndicatorView(style: .large)
	private let disposeBag = DisposeBag()
	
	private var rankingPositions = [RankingPosition]()
	
	init(presenter: RankingPresenting) {
		self.presenter = presenter
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
			make.edges.equalToSuperview()
		}
	}
	
	private func setupBindings() {
		let output = presenter.transform()
		
		output.rankingPositions
			.drive { [weak self] positions in
				self?.rankingPositions = positions
				self?.tableView.reloadData()
			}
			.disposed(by: disposeBag)
		
		output.isFetchingData
			.drive(activityIndicatorView.rx.isAnimating)
			.disposed(by: disposeBag)
	}
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(RankingCell.self)
		tableView.backgroundColor = Assets.Colors.backgroundWarm.color
		tableView.separatorStyle = .none
	}
	
	private func setupNavigationBar() {
		navigationItem.title = "Ranking"
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.standardAppearance = .standard
		navigationController?.navigationBar.tintColor = Assets.Colors.action.color.withAlphaComponent(0.7)
	}
}

extension RankingViewController: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		rankingPositions.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(for: indexPath) as RankingCell
		let position = rankingPositions[indexPath.row]
		
		cell.update(with: position)
		
		return cell
	}
}
