//
//  RankingPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 25/08/2021.
//

import RxSwift
import RxCocoa

protocol RankingPresenting {
	func transform() -> RankingPresenterOutput
}

struct RankingPresenterOutput {
	let isFetchingData: Driver<Bool>
	let rankingPositions: Driver<[RankingPosition]>
}

final class RankingPresenter: RankingPresenting {
		
	struct Context {
		let service: FamilyFriendAPI
	}
	
	private let context: Context
	
	private let isFetchingDataSubject = BehaviorSubject<Bool>(value: false)
	private let fetchedCompletedTasksSubject = BehaviorSubject<[Task]>(value: [])
	private let rankingPositionsSubject = BehaviorSubject<[RankingPosition]>(value: [])
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform() -> RankingPresenterOutput {
		fetchCompletedTasks()
		
		let output = RankingPresenterOutput(
			isFetchingData: isFetchingDataSubject.asDriverOnErrorJustComplete(),
			rankingPositions: rankingPositions()
		)
		
		return output
	}
	
	private func fetchCompletedTasks() {
		isFetchingDataSubject.onNext(true)
		return context.service
			.getTasks()
			.asDriverOnErrorJustComplete()
			.map { $0.filter { $0.completed } }
			.drive { [fetchedCompletedTasksSubject] tasks in
				fetchedCompletedTasksSubject.onNext(tasks)
			} onCompleted: { [isFetchingDataSubject] in
				isFetchingDataSubject.onNext(false)
			}
			.disposed(by: disposeBag)
	}
	
	private func rankingPositions() -> Driver<[RankingPosition]> {
		fetchedCompletedTasksSubject
			.asDriverOnErrorJustComplete()
			.map(calculateRankingPositions(from:))
	}
	
	private func calculateRankingPositions(from tasks: [Task]) -> [RankingPosition] {
		var membersPoints = [String : Int]()
		for task in tasks {
			let points = membersPoints[task.assignedMemberName] ?? 0
			membersPoints.updateValue(points + task.xpPoints, forKey: task.assignedMemberName)
		}
		
		var membersPositions = [RankingPosition]()
		for (index, points) in membersPoints.sorted(by: { $0.value > $1.value }).enumerated() {
			membersPositions.append(RankingPosition(memberName: points.key , place: index + 1, points: points.value))
		}
		
		return membersPositions
	}
}
