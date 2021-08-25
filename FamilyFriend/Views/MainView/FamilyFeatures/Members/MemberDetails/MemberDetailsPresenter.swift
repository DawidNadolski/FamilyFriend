//
//  MemberDetailsPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 24/08/2021.
//

import RxSwift
import RxCocoa

protocol MemberDetailsPresenting {
	func transform() -> MemberDetailsPresenterOutput
}

struct MemberDetailsPresenterOutput {
	let memberActiveTasks: Driver<[Task]>
	let isFetchingData: Driver<Bool>
}

final class MemberDetailsPresenter: MemberDetailsPresenting {
	
	struct Context {
		let member: Member
		let service: FamilyFriendAPI
	}
	
	private let context: Context
	
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let fetchedTasksSubject = BehaviorSubject<[Task]>(value: [])
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform() -> MemberDetailsPresenterOutput {
		let memberActiveTasks = fetchedTasksSubject
			.asDriverOnErrorJustComplete()
			.map { [context] in
				$0.filter { $0.assignedMemberId == context.member.id && !$0.completed }
			}
			
		let output = MemberDetailsPresenterOutput(
			memberActiveTasks: memberActiveTasks,
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete()
		)
		
		return output
	}
	
	private func fetchData() {
		isFetchingDataSubject.onNext(true)
		context.service
			.getTasks()
			.asDriverOnErrorJustComplete()
			.drive { [fetchedTasksSubject] fetchedTasks in
				fetchedTasksSubject.onNext(fetchedTasks)
			} onCompleted: { [isFetchingDataSubject] in
				isFetchingDataSubject.onNext(false)
			}
			.disposed(by: disposeBag)

	}
}
