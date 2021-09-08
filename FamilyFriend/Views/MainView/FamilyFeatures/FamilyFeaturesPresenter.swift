//
//  FamilyFeaturesPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 23/07/2021.
//

import RxCocoa
import RxSwift

protocol FamilyFeaturesPresenting {
	func transform(input: FamilyFeaturesPresenterInput)
}

struct FamilyFeaturesPresenterInput {
	let membersFeatureSelected: ControlEvent<Void>
	let rankingFeatureSelected: ControlEvent<Void>
	let shoppingListFeatureSelected: ControlEvent<Void>
	let tasksFeatureSelected: ControlEvent<Void>
}

struct FamilyFeaturesPresenterOutput {
	
}

final class FamilyFeaturesPresenter: FamilyFeaturesPresenting {
	
	struct Context {
		let familyFeaturesViewRoutes: FamilyFeaturesViewRoutes
	}
	
	private let context: Context
	
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: FamilyFeaturesPresenterInput) {
		
		input.membersFeatureSelected
			.asDriver()
			.drive(context.familyFeaturesViewRoutes.toMembersFeature)
			.disposed(by: disposeBag)
		
		input.rankingFeatureSelected
			.asDriver()
			.drive(context.familyFeaturesViewRoutes.toRankingFeature)
			.disposed(by: disposeBag)
		
		input.shoppingListFeatureSelected
			.asDriver()
			.drive(context.familyFeaturesViewRoutes.toShoppingListsFeature)
			.disposed(by: disposeBag)
		
		input.tasksFeatureSelected
			.asDriver()
			.drive(context.familyFeaturesViewRoutes.toTasksFeature)
			.disposed(by: disposeBag)
	}
}
