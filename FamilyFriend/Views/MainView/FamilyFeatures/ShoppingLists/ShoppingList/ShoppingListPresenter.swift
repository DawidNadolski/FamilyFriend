//
//  ShoppingListPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 05/08/2021.
//

import RxSwift
import RxCocoa

protocol ShoppingListPresenting {
	func transform(input: ShoppingListPresenterInput)
}

struct ShoppingListPresenterInput {
	let addComponentButtonPressed: ControlEvent<Void>
	let componentSelected: ControlEvent<ShoppingListComponent?>
}

final class ShoppingListPresenter: ShoppingListPresenting {
	
	struct Context {
		let shoppingListViewRoutes: ShoppingListViewRoutes
	}
	
	private let context: Context
	
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: ShoppingListPresenterInput) {
		input
			.addComponentButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(context.shoppingListViewRoutes.toAddComponent)
			.disposed(by: disposeBag)
	}
}
