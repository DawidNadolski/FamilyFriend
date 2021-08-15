//
//  Rx+Extensions.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 13/07/2021.
//

import RxSwift
import RxCocoa
import UIKit

extension ObservableType {
	func mapToVoid() -> Observable<Void> {
		map { _ in }
	}

	func asDriverOnErrorJustComplete() -> Driver<Element> {
		asDriver { _ in
			Driver.empty()
		}
	}
}

extension Completable {
	static func just(_ block: @escaping () throws -> Void) -> Completable {
		Completable.create { observer in
			do {
				try block()
				observer(.completed)
			} catch let error {
				observer(.error(error))
			}
			return Disposables.create()
		}
	}

	func catchErrorJustComplete() -> Completable {
		self.catchError { _ in .empty() }
	}
}

extension Reactive where Base: UIViewController {

	var viewWillAppear: ControlEvent<Bool> {
		let source = methodInvoked(#selector(Base.viewWillAppear)).map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}

	var viewDidAppear: ControlEvent<Bool> {
		let source = methodInvoked(#selector(Base.viewDidAppear)).map { $0.first as? Bool ?? false }
		return ControlEvent(events: source)
	}
}

extension Reactive where Base: UNUserNotificationCenter {

	func requestAuthorization() -> Single<Bool> {
		Single.create { single -> Disposable in
			self.base.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
				if let error = error {
					single(.error(error))
					return
				}

				single(.success(granted))
			}

			return Disposables.create()
		}
	}
}

