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
	private let xpPointsTextField = makeTextField()
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
	
	private let pickAssigneeLabel: UILabel = {
		let label = UILabel()
		label.textAlignment = .center
		label.textColor = Assets.Colors.textPrimary.color
		label.text = "Assign to"
		label.font = FontFamily.SFProText.semibold.font(size: 17.0)
		return label
	}()
	
	private let assigneePicker: UIPickerView = {
		let pickerView = UIPickerView()
		return pickerView
	}()
	
	private let doneButton: UIButton = {
		let button = makeRoundedPrimaryButton()
		button.setTitle("Done", for: .normal)
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
			make.top.equalTo(xpPointsTextField.snp.bottom).offset(42.0)
			make.left.right.equalToSuperview()
		}
		
		view.addSubview(assigneePicker)
		assigneePicker.snp.makeConstraints { make in
			make.top.equalTo(pickAssigneeLabel.snp.bottom).offset(12)
			make.height.equalTo(42.0)
			make.left.right.equalToSuperview().inset(8.0)
		}
		
		view.addSubview(doneButton)
		doneButton.snp.makeConstraints { make in
			make.top.equalTo(assigneePicker.snp.bottom).offset(128.0)
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
			nameText: nameTextField.rx.text.asDriverOnErrorJustComplete(),
			xpPoints: xpPointsTextField.rx.text.asDriverOnErrorJustComplete().map{ $0 != nil ? Int($0!) : nil },
			assignedMember: assigneePicker.rx.itemSelected.map { [members] in members[$0.row] }.asDriverOnErrorJustComplete(),
			addButtonPressed: ControlEvent<Task>(
				events: doneButton.rx.tap.map { [nameTextField, xpPointsTextField] _ in
					return Task(
						taskID: 1,
						name: nameTextField.text!,
						description: "",
						xpPoints: Int(xpPointsTextField.text!)!,
						executingMemberID: nil,
						assignmentDate: nil,
						dueDate: nil,
						completed: false
					)
			 }),
			cancelButtonPressed: cancelButton.rx.tap
		)
		
		let output = presenter.transform(input: input)
		
		output.isAddButtonEnabled
			.drive(doneButton.rx.isEnabled)
			.disposed(by: disposeBag)
	}
}
