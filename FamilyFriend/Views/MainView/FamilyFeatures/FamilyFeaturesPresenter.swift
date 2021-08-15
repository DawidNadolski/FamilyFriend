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
		let mainViewRoutes: MainViewRoutes
	}
	
	private let context: Context
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: FamilyFeaturesPresenterInput) {
		
		input.membersFeatureSelected
			.asDriver()
			.drive(membersFeatureBinder)
			.disposed(by: disposeBag)
		
		input.rankingFeatureSelected
			.asDriver()
			.drive(rankingFeatureBinder)
			.disposed(by: disposeBag)
		
		input.shoppingListFeatureSelected
			.asDriver()
			.drive(shoppingListFeatureBinder)
			.disposed(by: disposeBag)
		
		input.tasksFeatureSelected
			.asDriver()
			.drive(tasksFeatureBinder)
			.disposed(by: disposeBag)
	}
	
	private var membersFeatureBinder: Binder<Void> {
		Binder(self) { presenter, _ in
			presenter.context.mainViewRoutes.toMembersFeature.onNext(())
		}
	}
	
	private var rankingFeatureBinder: Binder<Void> {
		Binder(self) { presenter, _ in
			print("Ranking feature selected!")
		}
	}
	
	private var shoppingListFeatureBinder: Binder<Void> {
		Binder(self) { presenter, _ in
			presenter.context.mainViewRoutes.toShoppingListFeature.onNext(())
		}
	}
	
	private var tasksFeatureBinder: Binder<Void> {
		Binder(self) { presenter, _ in
			presenter.context.mainViewRoutes.toTasksFeature.onNext(())
		}
	}
}
