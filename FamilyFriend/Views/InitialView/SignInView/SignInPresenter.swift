//
//  SignInPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import RxSwift
import RxCocoa

protocol SignInPresenting {
	func transform(_ input: SignInPresenterInput) -> SignInPresenterOutput
}

struct SignInPresenterInput {
	let emailText: Observable<String>
	let passwordText: Observable<String>
	let signInButtonPressed: ControlEvent<(String, String)>
}

struct SignInPresenterOutput {
	let isSignInButtonEnabled: Driver<Bool>
	let isFetchingData: Driver<Bool>
	let occurredError: Driver<Error?>
}

final class SignInPresenter: SignInPresenting {
	
	struct Context {
		let service: FamilyFriendAPI
		let signInViewRoutes: SignInViewRoutes
	}
	
	private let context: Context
	
	private let isSignInButtonEnabledSubject = BehaviorSubject<Bool>(value: false)
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let errorSubject = BehaviorSubject<Error?>(value: nil)
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(_ input: SignInPresenterInput) -> SignInPresenterOutput {
		Observable.combineLatest(
			input.emailText,
			input.passwordText
		)
		.asDriverOnErrorJustComplete()
		.drive(validateCredentialsBinder)
		.disposed(by: disposeBag)
		
		input.signInButtonPressed
			.asDriver()
			.drive(signInBinder)
			.disposed(by: disposeBag)
		
		let output = SignInPresenterOutput(
			isSignInButtonEnabled: isSignInButtonEnabledSubject.asDriverOnErrorJustComplete(),
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete(),
			occurredError: errorSubject.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private var validateCredentialsBinder: Binder<(String, String)> {
		Binder(self) { presenter, credentials in
			let (email, password) = credentials
			
			guard
				!email.isEmpty,
				!password.isEmpty
			else {
				presenter.isSignInButtonEnabledSubject.onNext(false)
				return
			}
			
			presenter.isSignInButtonEnabledSubject.onNext(true)
		}
	}
	
	private var signInBinder: Binder<(String, String)> {
		Binder(self) { presenter, credentials in
			let (username, password) = credentials
						
			let credentials = UserCredentials(username: username, password: password)
			
			presenter.isFetchingDataSubject.onNext(true)
			presenter.context.service
				.signIn(with: credentials) { [weak self] result in
					switch result {
					case .success(let session):
						self?.isFetchingDataSubject.onNext(false)
						DispatchQueue.main.async {
							self?.signIn(with: session)
						}
					case .failure(let error):
						self?.isFetchingDataSubject.onNext(false)
						self?.errorSubject.onNext(error)
					}
				}
			}
	}
	
	private func signIn(with session: UserSession) {
		context.service.getMembers()
			.asDriverOnErrorJustComplete()
			.map { $0.map { Member(from: $0) } }
			.drive { [weak self] fetchedMembers in
				var foundMember: Member? = nil
				for member in fetchedMembers {
					if member.id == session.user.id {
						foundMember = member
						break
					}
				}
				self?.handleUserMembership(member: foundMember, in: session)
			}
			.disposed(by: disposeBag)
	}
	
	private func handleUserMembership(member: Member?, in session: UserSession) {
		guard let member = member else {
			context.signInViewRoutes.toSetupFamily.onNext(session)
			return
		}
		
		findFamily(for: member)
			.compactMap { $0 }
			.drive { [context] family in
				context.signInViewRoutes.toMainView.onNext((family, member))
			}
			.disposed(by: disposeBag)
	}
	
	private func findFamily(for member: Member) -> Driver<Family?> {
		context.service.getFamilies()
			.asDriverOnErrorJustComplete()
			.map { fetchedFamilies in
				var foundFamily: Family? = nil
				for family in fetchedFamilies {
					if family.id == member.familyId {
						foundFamily = family
					}
				}
				return foundFamily
			}
	}
}
