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
	let moreButtonTapped: ControlEvent<Void>
	let settingsButtonTapped: ControlEvent<Void>
}

final class FamilySummaryPresenter: FamilySummaryPresenting {
	
	struct Context {
		
	}
	
	private let context: Context
	private let disposeBag = DisposeBag()
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: FamilySummaryPresenterInput) {
		
		input.moreButtonTapped
			.asDriver()
			.drive(moreButtonBinder)
			.disposed(by: disposeBag)
		
		input.settingsButtonTapped
			.asDriver()
			.drive(settingsButtonBinder)
			.disposed(by: disposeBag)
	}
	
	private var moreButtonBinder: Binder<Void> {
		Binder(self) { presenter, _ in
			print("More button tapped!")
		}
	}
	
	private var settingsButtonBinder: Binder<Void> {
		Binder(self) { presenter, _ in
			print("Settings button tapped!")
		}
	}
}
