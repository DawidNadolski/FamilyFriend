//
//  ShoppingListPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 05/08/2021.
//

import RxSwift
import RxCocoa

protocol ShoppingListsPresenting {
	func transform(input: ShoppingListsPresentingInput) -> ShoppingListsPresentingOutput
}

struct ShoppingListsPresentingInput {
	let listSelected: ControlEvent<ShoppingList?>
	let listDeleted: ControlEvent<ShoppingList?>
	let addListPressed: ControlEvent<Void>
}

struct ShoppingListsPresentingOutput {
	let isFetchingData: Driver<Bool>
	let fetchedLists: Driver<[ShoppingList]>
}

final class ShoppingListsPresenter: ShoppingListsPresenting {
	
	struct Context {
		let shoppingListsViewRoutes: ShoppingListsViewRoutes
		let service: FamilyFriendAPI
	}
	
	private let context: Context
	
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let shoppingListsSubject = BehaviorSubject<[ShoppingList]>(value: [])
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: ShoppingListsPresentingInput) -> ShoppingListsPresentingOutput {
		fetchData()
		
		input.listSelected
			.compactMap { $0 }
			.asDriverOnErrorJustComplete()
			.drive(context.shoppingListsViewRoutes.toShoppingList)
			.disposed(by: disposeBag)
		
		input.listDeleted
			.compactMap { $0 }
			.asDriverOnErrorJustComplete()
			.drive { [context] in context.service.deleteShoppingList($0) }
			.disposed(by: disposeBag)
		
		input.addListPressed
			.asDriverOnErrorJustComplete()
			.drive(context.shoppingListsViewRoutes.toAddList)
			.disposed(by: disposeBag)
		
		let output = ShoppingListsPresentingOutput(
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete(),
			fetchedLists: shoppingListsSubject.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private func fetchData() {
		isFetchingDataSubject.onNext(true)
		context.service
			.getShoppingLists()
			.asDriverOnErrorJustComplete()
			.drive { [shoppingListsSubject] lists in
				shoppingListsSubject.onNext(lists)
			} onCompleted: { [isFetchingDataSubject] in
				isFetchingDataSubject.onNext(false)
			}
			.disposed(by: disposeBag)
	}
}
