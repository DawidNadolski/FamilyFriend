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
	
	func transform(input: ShoppingListPresenterInput) {
		
	}
}
