//
//  FamilySummaryPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 23/07/2021.
//

import RxSwift
import RxCocoa

protocol FamilySummaryPresenting {
	func transform(input: FamilySummaryPresenterInput)
}

struct FamilySummaryPresenterInput {
	let settingsButtonTapped: ControlEvent<Void>
	let memberDetailsButtonTapped: ControlEvent<Void>
}

final class FamilySummaryPresenter: FamilySummaryPresenting {
	
	struct Context {
		let familySummaryViewRoutes: FamilySummaryViewRoutes
	}
	
	private let context: Context
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: FamilySummaryPresenterInput) {
		input.settingsButtonTapped
			.asDriver()
			.drive(context.familySummaryViewRoutes.toSettings)
			.disposed(by: disposeBag)
		
		input.memberDetailsButtonTapped
			.asDriver()
			.drive(context.familySummaryViewRoutes.toMemberDetails)
			.disposed(by: disposeBag)
	}
}
