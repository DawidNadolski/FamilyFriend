//
//  ShoppingListPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 05/08/2021.
//

import RxSwift
import RxCocoa

protocol ShoppingListPresenting {
	func transform(input: ShoppingListPresenterInput) -> ShoppingListPresenterOutput
}

struct ShoppingListPresenterInput {
	let addComponentButtonPressed: ControlEvent<Void>
	let componentSelected: ControlEvent<ShoppingListComponent?>
	let componentDeleted: ControlEvent<ShoppingListComponent?>
}

struct ShoppingListPresenterOutput {
	let fetchedComponents: Driver<[ShoppingListComponent]>
	let isFetchingData: Driver<Bool>
}

final class ShoppingListPresenter: ShoppingListPresenting {
	
	struct Context {
		let shoppingList: ShoppingList
		let shoppingListViewRoutes: ShoppingListViewRoutes
		let service: FamilyFriendAPI
	}
	
	private let context: Context
	
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let componentsSubject = BehaviorSubject<[ShoppingListComponent]>(value: [])
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: ShoppingListPresenterInput) -> ShoppingListPresenterOutput {
		fetchData()
		
		input.addComponentButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(context.shoppingListViewRoutes.toAddComponent)
			.disposed(by: disposeBag)
		
		input.componentDeleted
			.compactMap { $0 }
			.asDriverOnErrorJustComplete()
			.drive { [context] in context.service.deleteShoppingListComponent($0) }
			.disposed(by: disposeBag)
		
		let output = ShoppingListPresenterOutput(
			fetchedComponents: componentsSubject.asDriverOnErrorJustComplete(),
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private func fetchData() {
		isFetchingDataSubject.onNext(true)
		context.service
			.getShoppingListComponents()
			.asDriverOnErrorJustComplete()
			.drive { [context, componentsSubject] components in
				componentsSubject.onNext(components.filter { $0.listId == context.shoppingList.id })
			} onCompleted: { [isFetchingDataSubject] in
				isFetchingDataSubject.onNext(false)
			}
			.disposed(by: disposeBag)
	}
}
