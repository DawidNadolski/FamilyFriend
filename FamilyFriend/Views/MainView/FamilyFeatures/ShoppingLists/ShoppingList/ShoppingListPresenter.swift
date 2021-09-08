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
	let componentDeleted: ControlEvent<ShoppingListComponent?>
	let componentAdded: ControlEvent<ShoppingListComponent?>
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
	private let componentsRelay = BehaviorRelay<[ShoppingListComponent]>(value: [])
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: ShoppingListPresenterInput) -> ShoppingListPresenterOutput {
		fetchComponents()
		
		input.addComponentButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(context.shoppingListViewRoutes.toAddComponent)
			.disposed(by: disposeBag)
		
		input.componentDeleted
			.compactMap { $0 }
			.asDriverOnErrorJustComplete()
			.drive { [context] in
				context.service.deleteShoppingListComponent($0)
			}
			.disposed(by: disposeBag)
		
		input.componentAdded
			.compactMap { $0 }
			.asDriverOnErrorJustComplete()
			.drive(addComponentBinder)
			.disposed(by: disposeBag)
		
		let output = ShoppingListPresenterOutput(
			fetchedComponents: componentsRelay.asDriverOnErrorJustComplete(),
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private var addComponentBinder: Binder<ShoppingListComponent> {
		Binder(self) { presenter, addedComponent in
			var components = presenter.componentsRelay.value
			components.append(addedComponent)
			presenter.componentsRelay.accept(components)
		}
	}
	
	private func fetchComponents() {
		isFetchingDataSubject.onNext(true)
		context.service
			.getShoppingListComponents()
			.map { [context] in $0.filter { $0.shoppingList.id == context.shoppingList.id } }
			.map { $0.map { ShoppingListComponent(from: $0) } }
			.asDriverOnErrorJustComplete()
			.drive { [componentsRelay] components in
				componentsRelay.accept(components)
			} onCompleted: { [isFetchingDataSubject] in
				isFetchingDataSubject.onNext(false)
			}
			.disposed(by: disposeBag)
	}
}
