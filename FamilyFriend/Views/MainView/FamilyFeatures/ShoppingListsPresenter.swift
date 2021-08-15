//
//  ShoppingListPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 05/08/2021.
//

import RxSwift
import RxCocoa

protocol ShoppingListsPresenting {
	func transform(input: ShoppingListsPresentingInput)
}

struct ShoppingListsPresentingInput {
	let listSelected: ControlEvent<ShoppingList?>
	let addListPressed: ControlEvent<Void>
}

final class ShoppingListsPresenter: ShoppingListsPresenting {
	
	struct Context {
		let toShoppingList: Binder<ShoppingList>
		let toAddList: Binder<Void>
	}
	
	private let disposeBag = DisposeBag()
	private let context: Context
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: ShoppingListsPresentingInput) {
		input.listSelected
			.compactMap { $0 }
			.asDriverOnErrorJustComplete()
			.drive(context.toShoppingList)
			.disposed(by: disposeBag)
		
		input.addListPressed
			.asDriverOnErrorJustComplete()
			.drive(context.toAddList)
			.disposed(by: disposeBag)
	}
}
