//
//  MembersPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 27/07/2021.
//

import RxCocoa
import RxSwift

protocol MembersPresenting {
	func transform(input: MembersPresenterInput) -> MembersPresenterOutput
}

struct MembersPresenterInput {
	let memberSelected: ControlEvent<Member?>
}

struct MembersPresenterOutput {
	let isFetchingData: Driver<Bool>
	let fetchedMembers: Driver<[Member]>
}

final class MembersPresenter: MembersPresenting {
	
	struct Context {
		let membersViewRoutes: MembersViewRoutes
		let service: FamilyFriendAPI
		let family: Family
	}
	
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let fetchedMembersSubject = BehaviorSubject<[Member]>(value: [])
	private let disposeBag = DisposeBag()
	
	private let context: Context
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: MembersPresenterInput) -> MembersPresenterOutput {
		fetchData()
		
		input.memberSelected
			.compactMap { $0 }
			.asDriverOnErrorJustComplete()
			.drive(context.membersViewRoutes.toMemberDetails)
			.disposed(by: disposeBag)
		
		return .init(
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete(),
			fetchedMembers: fetchedMembersSubject.asDriverOnErrorJustComplete()
		)
	}
	
	private func fetchData() {
		isFetchingDataSubject.onNext(true)
		context.service
			.getMembers()
			.map { [context] in $0.filter { $0.family.id == context.family.id } }
			.map { $0.map { Member(from: $0) } }
			.asDriverOnErrorJustComplete()
			.drive { [fetchedMembersSubject] fetchedMembers in
				fetchedMembersSubject.onNext(fetchedMembers)
			} onCompleted: { [isFetchingDataSubject] in
				isFetchingDataSubject.onNext(false)
			}
			.disposed(by: disposeBag)
	}
}
