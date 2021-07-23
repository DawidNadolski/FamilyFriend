//
//  RankingViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 11/07/2021.
//

import UIKit

final class RankingViewController: UIViewController {
	
	let containerView = TileView()
	
	private let imageView: UIImageView = {
		let imageView = UIImageView(image: UIImage(systemName: "list.number"))
		return imageView
	}()
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		view.addSubview(containerView)
		containerView.backgroundColor = .white
		containerView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		containerView.addSubview(imageView)
		imageView.snp.makeConstraints { make in
			make.top.left.bottom.equalToSuperview().inset(8.0)
			make.size.equalTo(64.0)
		}
	}
}
