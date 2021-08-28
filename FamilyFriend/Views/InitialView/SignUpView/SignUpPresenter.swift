//
//  SignUpPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 27/08/2021.
//

import RxSwift
import RxCocoa

protocol SignUpPresenting {
	func transform(_ input: SignUpPresenterInput) -> SignUpPresenterOutput
}

struct SignUpPresenterInput {
	let emailText: Observable<String>
	let passwordText: Observable<String>
	let repeatedPasswordText: Observable<String>
	let signUpButtonPressed: ControlEvent<(String, String)>
}

struct SignUpPresenterOutput {
	let shouldShowPasswordNotEqualLabel: Driver<Bool>
	let isSignUpButtonEnabled: Driver<Bool>
	let isFetchingData: Driver<Bool>
	let occurredError: Driver<Error?>
}

final class SignUpPresenter: SignUpPresenting {
	
	struct Context {
		let service: FamilyFriendAPI
		let signUpViewRoutes: SignUpViewRoutes
	}
	
	private let context: Context
	
	private let passwordsNotEqualSubject = BehaviorSubject<Bool>(value: false)
	private let isAddButtonEnabledSubject = BehaviorSubject<Bool>(value: false)
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let errorSubject = BehaviorSubject<Error?>(value: nil)
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(_ input: SignUpPresenterInput) -> SignUpPresenterOutput {
		Observable.combineLatest(
			input.emailText,
			input.passwordText,
			input.repeatedPasswordText
		)
		.asDriverOnErrorJustComplete()
		.drive(validateCredentialsBinder)
		.disposed(by: disposeBag)
		
		input.signUpButtonPressed
			.asDriver()
			.drive(signUpBinder)
			.disposed(by: disposeBag)
		
		let output = SignUpPresenterOutput(
			shouldShowPasswordNotEqualLabel: passwordsNotEqualSubject.asDriverOnErrorJustComplete(),
			isSignUpButtonEnabled: isAddButtonEnabledSubject.asDriverOnErrorJustComplete(),
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete(),
			occurredError: errorSubject.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private var validateCredentialsBinder: Binder<(String, String, String)> {
		Binder(self) { presenter, credentials in
			let (email, password, repeatedPassword) = credentials
			
			guard
				!email.isEmpty,
				!password.isEmpty, password.count >= 8,
				!repeatedPassword.isEmpty
			else {
				presenter.isAddButtonEnabledSubject.onNext(false)
				return
			}
			
			if !password.isEmpty, !repeatedPassword.isEmpty, password != repeatedPassword {
				presenter.passwordsNotEqualSubject.onNext(true)
				presenter.isAddButtonEnabledSubject.onNext(false)
			} else {
				presenter.passwordsNotEqualSubject.onNext(false)
				presenter.isAddButtonEnabledSubject.onNext(true)
			}
		}
	}
	
	private var signUpBinder: Binder<(String, String)> {
		Binder(self) { presenter, credentials in
			let (username, password) = credentials
						
			let credentials = UserCredentials(username: username, password: password)
			
			// TODO: Resolve signing up
//			presenter.isFetchingDataSubject.onNext(true)
//			presenter.context.service
//				.signUp(with: credentials) { [weak self] result in
//					switch result {
//						case .success(let session):
//							self?.isFetchingDataSubject.onNext(false)
//							self?.signUp(with: session)
//						case .failure(let error):
//							self?.isFetchingDataSubject.onNext(false)
//							self?.errorSubject.onNext(error)
//					}
//				}
			
			presenter.signUp(with: UserSession(token: "", user: User(username: "", id: UUID(), updatedAt: "", createdAt: "")))
		}
	}
	
	private func signUp(with session: UserSession) {
		context.signUpViewRoutes.toSetupFamily.onNext(session)
	}
}
