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
	
}

final class MembersPresenter: MembersPresenting {
	
	struct Context {
		let toMemberDetails: Binder<Member>
	}
	
	private let disposeBag = DisposeBag()
	private let context: Context
	
	init(context: Context) {
		self.context = context
	}
	
	func transform(input: MembersPresenterInput) -> MembersPresenterOutput {
		input.memberSelected
			.compactMap { $0 }
			.asDriverOnErrorJustComplete()
			.drive(context.toMemberDetails)
			.disposed(by: disposeBag)
		
		return .init()
	}
}
