//
//  CreateFamilyPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import RxSwift
import RxCocoa

protocol CreateFamilyPresenting {
	func transform(_ input: CreateFamilyPresenterInput) -> CreateFamilyPresenterOutput
}

struct CreateFamilyPresenterInput {
	let familyNameText: Observable<String>
	let familyPasswordText: Observable<String>
	let createFamilyButtonPressed: ControlEvent<(String, String)>
}

struct CreateFamilyPresenterOutput {
	let isCreateFamilyButtonEnabled: Driver<Bool>
	let isFetchingData: Driver<Bool>
}

final class CreateFamilyPresenter: CreateFamilyPresenting {
	
	struct Context {
		let service: FamilyFriendAPI
	}
	
	private let context: Context
	
	private let isCreateFamilyButtonEnabledSubject = BehaviorSubject<Bool>(value: false)
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(_ input: CreateFamilyPresenterInput) -> CreateFamilyPresenterOutput {
		Observable.combineLatest(
			input.familyNameText,
			input.familyPasswordText
		)
		.asDriverOnErrorJustComplete()
		.drive(validateCredentials)
		.disposed(by: disposeBag)
		
		input.createFamilyButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(createFamilyBinder)
			.disposed(by: disposeBag)
		
		let output = CreateFamilyPresenterOutput(
			isCreateFamilyButtonEnabled: isCreateFamilyButtonEnabledSubject.asDriverOnErrorJustComplete(),
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private var validateCredentials: Binder<(String, String)> {
		Binder(self) { presenter, credentials in
			let (familyId, password) = credentials
			
			guard !familyId.isEmpty, password.count >= 8 else {
				presenter.isCreateFamilyButtonEnabledSubject.onNext(false)
				return
			}
			presenter.isCreateFamilyButtonEnabledSubject.onNext(true)
		}
	}
	
	private var createFamilyBinder: Binder<(String, String)> {
		Binder(self) { presenter, credentials in
			// TODO: Create new family and go to main view
			let (name, password) = credentials
			let family = Family(id: UUID(), name: name, password: password)
			presenter.isFetchingDataSubject.onNext(true)
		}
	}
}
