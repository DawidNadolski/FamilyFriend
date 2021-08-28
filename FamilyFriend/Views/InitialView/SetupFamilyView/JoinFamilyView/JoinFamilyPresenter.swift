//
//  JoinFamilyPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import RxSwift
import RxCocoa

protocol JoinFamilyPresenting {
	func transform(_ input: JoinFamilyPresenterInput) -> JoinFamilyPresenterOutput
}

struct JoinFamilyPresenterInput {
	let memberNameText: Observable<String>
	let familyIdText: Observable<String>
	let familyPasswordText: Observable<String>
	let joinFamilyButtonPressed: ControlEvent<(String, String, String)>
}

struct JoinFamilyPresenterOutput {
	let isJoinFamilyButtonEnabled: Driver<Bool>
	let isFetchingData: Driver<Bool>
	let occurredError: Driver<Error?>
}

final class JoinFamilyPresenter: JoinFamilyPresenting {
	
	struct Context {
		let service: FamilyFriendAPI
	}
	
	private let context: Context
	
	private let isJoinFamilyButtonEnabledSubject = BehaviorSubject<Bool>(value: false)
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let errorSubject = BehaviorSubject<Error?>(value: nil)
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(_ input: JoinFamilyPresenterInput) -> JoinFamilyPresenterOutput {
		Observable.combineLatest(
			input.memberNameText,
			input.familyIdText,
			input.familyPasswordText
		)
		.asDriverOnErrorJustComplete()
		.drive(validateCredentials)
		.disposed(by: disposeBag)
		
		input.joinFamilyButtonPressed
			.asDriverOnErrorJustComplete()
			.drive(joinFamilyBinder)
			.disposed(by: disposeBag)
		
		let output = JoinFamilyPresenterOutput(
			isJoinFamilyButtonEnabled: isJoinFamilyButtonEnabledSubject.asDriverOnErrorJustComplete(),
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete(),
			occurredError: errorSubject.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private var validateCredentials: Binder<(String, String, String)> {
		Binder(self) { presenter, credentials in
			let (memberName, familyId, password) = credentials
			
			guard !memberName.isEmpty, !familyId.isEmpty, !password.isEmpty else {
				presenter.isJoinFamilyButtonEnabledSubject.onNext(false)
				return
			}
			presenter.isJoinFamilyButtonEnabledSubject.onNext(true)
		}
	}
	
	private var joinFamilyBinder: Binder<(String, String, String)> {
		Binder(self) { presenter, credentials in
			let (memberName, familyId, password) = credentials
			
			presenter.isFetchingDataSubject.onNext(true)
			// TODO: Check whether family exists and either show alert or go to mainview
		}
	}
}
