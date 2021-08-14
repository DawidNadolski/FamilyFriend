//
//  AddTaskPresenter.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 03/08/2021.
//

import RxCocoa

protocol AddTaskPresenting {
	func transform(input: AddTaskPresenterInput)
}

struct AddTaskPresenterInput {
	let doneButtonPressed: ControlEvent<Void>
}
