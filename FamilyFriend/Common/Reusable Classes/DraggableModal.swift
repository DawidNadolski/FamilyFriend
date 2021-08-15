//
//  DraggableModal.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 03/08/2021.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class DraggableModal: UIViewController {

	private enum PresentationType {
		case presentation
		case dismissal
	}

	private let modalView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		return view
	}()
	private let holdBarView: UIView = {
		let bar = UIView()
		bar.backgroundColor = Assets.Colors.backgroundCool.color
		bar.layer.cornerRadius = 2.0
		bar.snp.makeConstraints { make in
			make.width.equalTo(44.0)
			make.height.equalTo(4.0)
		}
		return bar
	}()
	private let embeddedViewController: UIViewController?
	private let shouldShowContentBelowSafeArea: Bool
	private let content: UIView
	private let disposeBag = DisposeBag()
	private var currentModalTransitionType: PresentationType?

	init(
		embeddedViewController: UIViewController,
		modalViewBackgroundColor: UIColor = UIColor.white,
		shouldShowContentBelowSafeArea: Bool = false
	) {
		self.content = embeddedViewController.view
		self.embeddedViewController = embeddedViewController
		self.shouldShowContentBelowSafeArea = shouldShowContentBelowSafeArea
		super.init(nibName: nil, bundle: nil)
		modalView.backgroundColor = modalViewBackgroundColor
		configurePresentationStyle()
	}

	init(content: UIView, shouldShowContentBelowSafeArea: Bool = false) {
		self.content = content
		self.embeddedViewController = nil
		self.shouldShowContentBelowSafeArea = shouldShowContentBelowSafeArea
		super.init(nibName: nil, bundle: nil)
		configurePresentationStyle()
	}

	required init?(coder: NSCoder) {
		fatalError("init?(coder: NSCoder) not implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		configureDragToDismiss()
		configureTapToDismiss()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		modalView.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
	}

	private func configurePresentationStyle() {
		transitioningDelegate = self
		modalPresentationStyle = .overFullScreen
	}

	private func configureUI() {
		view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
		view.addSubview(modalView)
		modalView.snp.makeConstraints { make in
			make.leading.trailing.bottom.equalToSuperview()
			make.top.greaterThanOrEqualTo(view.safeAreaLayoutGuide.snp.top).priority(.high)
		}

		modalView.addSubview(holdBarView)
		holdBarView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.top.equalToSuperview().inset(10.0)
		}

		if let embeddedViewController = embeddedViewController {
			add(embeddedViewController)
		}
		modalView.addSubview(content)
		content.snp.makeConstraints { make in
			make.top.equalTo(holdBarView.snp.bottom)
			make.leading.trailing.equalToSuperview()
			if shouldShowContentBelowSafeArea {
				make.bottom.equalToSuperview()
			} else {
				make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
			}
		}
	}

	private func configureDragToDismiss() {
		let panGesture = UIPanGestureRecognizer()
		panGesture.rx.event
			.subscribe(onNext: { [weak self] sender in
				self?.handleDragGesture(sender: sender)
			})
			.disposed(by: disposeBag)
		modalView.addGestureRecognizer(panGesture)
	}

	private func configureTapToDismiss() {
		let tapGesture = UITapGestureRecognizer()
		tapGesture.rx.event
			.subscribe(onNext: { [weak self] _ in
				self?.dismiss(animated: true)
			})
			.disposed(by: disposeBag)
		view.addGestureRecognizer(tapGesture)
		tapGesture.delegate = self
	}

	private func handleDragGesture(sender: UIPanGestureRecognizer) {
		guard let view = sender.view else {
			return
		}
		let translationY = max(sender.translation(in: view).y, 0.0)
		switch sender.state {
			case .changed:
				view.transform = CGAffineTransform(translationX: 0.0, y: translationY)
			case .ended, .cancelled:
				if translationY > view.frame.size.height * 0.4 {
					UIView.animate(
						withDuration: 0.3,
						delay: 0.0,
						usingSpringWithDamping: 1.0,
						initialSpringVelocity: 1.0,
						animations: {
							view.transform = CGAffineTransform(translationX: 0.0, y: view.frame.size.height)
							self.view.backgroundColor = .clear
						},
						completion: { _ in self.dismiss(animated: false) }
					)
				} else {
					UIView.animate(withDuration: 0.3) {
						self.modalView.transform = CGAffineTransform(translationX: 0.0, y: 0.0)
					}
				}
			case .failed, .possible, .began:
				break
			@unknown default:
				break
		}
	}
}

extension DraggableModal: UIGestureRecognizerDelegate {

	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		touch.view == view
	}
}

extension DraggableModal: UIViewControllerAnimatedTransitioning {

	private var transitionDuration: TimeInterval {
		guard let transitionType = currentModalTransitionType else {
			return 0.0
		}
		switch transitionType {
			case .presentation:
				return 0.44
			case .dismissal:
				return 0.3
		}
	}

	func transitionDuration(
		using transitionContext: UIViewControllerContextTransitioning?
	) -> TimeInterval {
		transitionDuration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		guard let transitionType = currentModalTransitionType else {
			return
		}

		let modalOffScreenState = {
			let offscreenY = self.view.bounds.height - self.modalView.frame.minY + 20.0
			self.modalView.transform = CGAffineTransform.identity.translatedBy(x: 0.0, y: offscreenY)
			self.view.backgroundColor = .clear
		}

		let presentedState = {
			self.modalView.transform = CGAffineTransform.identity
			self.view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
		}

		let animator: UIViewPropertyAnimator
		switch transitionType {
			case .presentation:
				animator = UIViewPropertyAnimator(duration: transitionDuration, dampingRatio: 0.82)
			case .dismissal:
				animator = UIViewPropertyAnimator(duration: transitionDuration, curve: UIView.AnimationCurve.easeIn)
		}

		switch transitionType {
			case .presentation:
				guard let toView = transitionContext.view(forKey: .to) else {
					return
				}
				UIView.performWithoutAnimation(modalOffScreenState)
				transitionContext.containerView.addSubview(toView)
				animator.addAnimations(presentedState)
			case .dismissal:
				animator.addAnimations(modalOffScreenState)
		}

		animator.addCompletion { _ in
			transitionContext.completeTransition(true)
			self.currentModalTransitionType = nil
		}
		animator.startAnimation()
	}
}

extension DraggableModal: UIViewControllerTransitioningDelegate {

	func animationController(
		forPresented presented: UIViewController,
		presenting: UIViewController,
		source: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		let result = (presented == self) ? self : nil
		result?.currentModalTransitionType = .presentation
		return result
	}

	func animationController(
		forDismissed dismissed: UIViewController
	) -> UIViewControllerAnimatedTransitioning? {
		let result = (dismissed == self) ? self : nil
		result?.currentModalTransitionType = .dismissal
		return result
	}
}

