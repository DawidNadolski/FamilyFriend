//
//  FamilyFeaturesViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 11/07/2021.
//

import RxSwift
import RxCocoa

final class FamilyFeaturesViewController: UIViewController {
	
	
	private let presenter: FamilyFeaturesPresenting
	private let rankingFeatureTileView = FeatureTileView(feature: .ranking)
	private let membersFeatureTileView = FeatureTileView(feature: .members)
	private let tasksFeatureTileView = FeatureTileView(feature: .tasks)
	private let shoppingListFeatureTileView = FeatureTileView(feature: .shoppingList)
	private let disposeBag = DisposeBag()
		
	private let featuresStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 16.0
		return stackView
	}()
		
	init(presenter: FamilyFeaturesPresenting) {
		self.presenter = presenter
		
		super.init(nibName: nil, bundle: nil)
		
		setupUI()
		setupBindings()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		view.backgroundColor = Assets.Colors.backgroundWarm.color
		
		view.addSubview(featuresStackView)
		featuresStackView.backgroundColor = Assets.Colors.backgroundWarm.color
		featuresStackView.snp.makeConstraints { make in
			make.top.bottom.equalToSuperview()
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		setupFeaturesView()
	}
	
	private func setupFeaturesView() {
		featuresStackView.addArrangedSubview(membersFeatureTileView)
		featuresStackView.addArrangedSubview(rankingFeatureTileView)
		featuresStackView.addArrangedSubview(shoppingListFeatureTileView)
		featuresStackView.addArrangedSubview(tasksFeatureTileView)
	}
	
	private func setupBindings() {
		let input = FamilyFeaturesPresenterInput(
			membersFeatureSelected: ControlEvent(events: membersFeatureTileView.tapRecognizer.rx.event.mapToVoid()),
			rankingFeatureSelected: ControlEvent(events: rankingFeatureTileView.tapRecognizer.rx.event.mapToVoid()),
			shoppingListFeatureSelected: ControlEvent(events: shoppingListFeatureTileView.tapRecognizer.rx.event.mapToVoid()),
			tasksFeatureSelected: ControlEvent(events: tasksFeatureTileView.tapRecognizer.rx.event.mapToVoid())
		)
		
		presenter.transform(input: input)
	}
}
