//
//  AddTaskViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 03/08/2021.
//

import RxSwift
import RxCocoa

final class AddTaskViewController: UIViewController {
	
	private let presenter: AddTaskPresenting
	
	private let nameTextField = makeTextField()
	private let pickerViewTopSeparator = makeSeparatorView()
	private let pickerViewBottomSeparator = makeSeparatorView()
	private let assigneePicker = UIPickerView()
	private let selectedMemberId = BehaviorRelay<Int?>(value: nil)
	private let disposeBag = DisposeBag()
	
	// TODO: Get rid of mock data
	private let members: [Member] = [
		.init(id: 1, name: "Dawid Nadolski", avatarURL: nil),
		.init(id: 2, name: "Mateusz Nadolski", avatarURL: nil),
		.init(id: 3, name: "Grażyna Nadolska", avatarURL: nil),
		.init(id: 4, name: "Grzegorz Nadolski", avatarURL: nil),
		.init(id: 5, name: "Agata Nadolska", avatarURL: nil)
	]
	
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = Assets.Colors.textPrimary.color
		label.text = "Add task"
		label.font = FontFamily.SFProText.bold.font(size: 17.0)
		return label
	}()
	
	private let setNameLabel: UILabel = {
		let label = UILabel()
		label.textColor = Assets.Colors.textPrimary.color
		label.text = "Task name"
		label.font = FontFamily.SFProText.semibold.font(size: 17.0)
		return label
	}()
	
	private let setXPPointsLabel: UILabel = {
		let label = UILabel()
		label.textColor = Assets.Colors.textPrimary.color
		label.text = "XP points"
		label.font = FontFamily.SFProText.semibold.font(size: 17.0)
		return label
	}()
	
	private let xpPointsTextField: UITextField = {
		let textField = makeTextField()
		textField.keyboardType = .numberPad
		textField.addDoneButtonToKeyboard()
		return textField
	}()
	
	private let pickAssigneeLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = Assets.Colors.textPrimary.color
		label.text = "Assign to"
		label.font = FontFamily.SFProText.semibold.font(size: 17.0)
		return label
	}()
	
	private let doneButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		button.setTitle("Done", for: .normal)
		button.setTitleColor(.white, for: .disabled)
		return button
	}()
	
	private let cancelButton: UIButton = {
		let button = makeRoundedSecondaryButton()
		button.setTitle("Cancel", for: .normal)
		return button
	}()
		
	init(presenter: AddTaskPresenting) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		setupUI()
		setupBindings()
		setupPickerView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setupUI() {
		view.backgroundColor = .white
		
		view.addSubview(titleLabel)
		titleLabel.snp.makeConstraints { make in
			make.height.equalTo(44.0)
			make.top.equalTo(view.snp.top).offset(8.0)
			make.left.right.equalToSuperview()
		}
		
		view.addSubview(setNameLabel)
		setNameLabel.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(16.0)
			make.right.left.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(nameTextField)
		nameTextField.snp.makeConstraints { make in
			make.top.equalTo(setNameLabel.snp.bottom).offset(6.0)
			make.height.equalTo(48.0)
			make.right.left.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(setXPPointsLabel)
		setXPPointsLabel.snp.makeConstraints { make in
			make.top.equalTo(nameTextField.snp.bottom).offset(12.0)
			make.right.left.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(xpPointsTextField)
		xpPointsTextField.snp.makeConstraints { make in
			make.top.equalTo(setXPPointsLabel.snp.bottom).offset(6.0)
			make.height.equalTo(48.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(pickAssigneeLabel)
		pickAssigneeLabel.snp.makeConstraints { make in
			make.top.equalTo(xpPointsTextField.snp.bottom).offset(36.0)
			make.left.right.equalToSuperview()
		}
		
		view.addSubview(pickerViewTopSeparator)
		pickerViewTopSeparator.snp.makeConstraints { make in
			make.top.equalTo(pickAssigneeLabel.snp.bottom).offset(12.0)
			make.height.equalTo(1.0)
			make.left.right.equalToSuperview().inset(4.0)
		}
		
		view.addSubview(assigneePicker)
		assigneePicker.snp.makeConstraints { make in
			make.top.equalTo(pickerViewTopSeparator.snp.bottom)
			make.height.equalTo(128.0)
			make.left.right.equalToSuperview()
		}
		
		view.addSubview(pickerViewBottomSeparator)
		pickerViewBottomSeparator.snp.makeConstraints { make in
			make.top.equalTo(assigneePicker.snp.bottom)
			make.height.equalTo(1.0)
			make.left.right.equalToSuperview().inset(4.0)
		}
		
		view.addSubview(doneButton)
		doneButton.snp.makeConstraints { make in
			make.top.equalTo(pickerViewBottomSeparator.snp.bottom).offset(24.0)
			make.height.equalTo(48.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(cancelButton)
		cancelButton.snp.makeConstraints { make in
			make.top.equalTo(doneButton.snp.bottom).offset(8.0)
			make.height.equalTo(48.0)
			make.left.right.equalToSuperview().inset(16.0)
			make.bottom.equalToSuperview().inset(24.0)
		}
	}
	
	private func setupBindings() {
		let input = AddTaskPresenterInput(
			nameText: nameTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
			xpPoints: xpPointsTextField.rx.text.orEmpty.distinctUntilChanged().asObservable(),
			assignedMemberId: selectedMemberId.asObservable(),
			addButtonPressed: ControlEvent<Task>(
				events: doneButton.rx.tap.map { [nameTextField, xpPointsTextField, selectedMemberId] _ in
					return Task(
						taskID: UUID(),
						name: nameTextField.text!,
						xpPoints: Int(xpPointsTextField.text!)!,
						executingMemberID: selectedMemberId.value!,
						completed: false
					)
			 }),
			cancelButtonPressed: cancelButton.rx.tap
		)
		
		let output = presenter.transform(input: input)
		
		output.isAddButtonEnabled
			.drive { [weak self] in self?.switchDoneButtonState(to: $0) }
			.disposed(by: disposeBag)
	}
	
	private func setupPickerView() {
		assigneePicker.dataSource = self
		assigneePicker.delegate = self
	}
	
	private func switchDoneButtonState(to isEnabled: Bool) {
		doneButton.isEnabled = isEnabled
		doneButton.backgroundColor = isEnabled ? Assets.Colors.action.color : Assets.Colors.iron.color.withAlphaComponent(0.5)
	}
}

extension AddTaskViewController: UIPickerViewDataSource, UIPickerViewDelegate {
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		members.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		members[row].name
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		selectedMemberId.accept(members[row].id)
	}
}
