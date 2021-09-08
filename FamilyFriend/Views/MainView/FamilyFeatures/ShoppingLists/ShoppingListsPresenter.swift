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
	let addListPressed: ControlEvent<Void>
	let listSelected: ControlEvent<ShoppingList?>
	let listDeleted: ControlEvent<ShoppingList?>
	let listAdded: ControlEvent<ShoppingList?>
}

struct ShoppingListsPresentingOutput {
	let isFetchingData: Driver<Bool>
	let fetchedLists: Driver<[ShoppingList]>
}

final class ShoppingListsPresenter: ShoppingListsPresenting {
	
	struct Context {
		let shoppingListsViewRoutes: ShoppingListsViewRoutes
		let service: FamilyFriendAPI
		let family: Family
	}
	
	private let context: Context
	
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let shoppingListsRelay = BehaviorRelay<[ShoppingList]>(value: [])
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
		
		input.listAdded
			.compactMap { $0 }
			.asDriverOnErrorJustComplete()
			.drive(addListBinder)
			.disposed(by: disposeBag)
		
		input.addListPressed
			.asDriverOnErrorJustComplete()
			.drive(context.shoppingListsViewRoutes.toAddList)
			.disposed(by: disposeBag)
		
		let output = ShoppingListsPresentingOutput(
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete(),
			fetchedLists: shoppingListsRelay.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private var addListBinder: Binder<ShoppingList> {
		Binder(self) { presenter, addedList in
			var lists = presenter.shoppingListsRelay.value
			lists.append(addedList)
			presenter.shoppingListsRelay.accept(lists)
		}
	}
	
	private func fetchData() {
		isFetchingDataSubject.onNext(true)
		context.service
			.getShoppingLists()
			.map { [context] in $0.filter { $0.family.id == context.family.id } }
			.map { $0.map { ShoppingList(from: $0) } }
			.asDriverOnErrorJustComplete()
			.drive { [shoppingListsRelay] lists in
				shoppingListsRelay.accept(lists)
			} onCompleted: { [isFetchingDataSubject] in
				isFetchingDataSubject.onNext(false)
			}
			.disposed(by: disposeBag)
	}
}
