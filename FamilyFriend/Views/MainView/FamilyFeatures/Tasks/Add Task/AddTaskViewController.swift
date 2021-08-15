//
//  AddTaskViewController.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 03/08/2021.
//

import UIKit

final class AddTaskViewController: UIViewController {
	
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
	
	private let nameTextfield: UITextField = {
		let textfield = UITextField()
		textfield.layer.cornerRadius = 12.0
		textfield.backgroundColor = Assets.Colors.pickerViewGrey.color
		return textfield
	}()
	
	private let setXPPointsLabel: UILabel = {
		let label = UILabel()
		label.textColor = Assets.Colors.textPrimary.color
		label.text = "XP points"
		label.font = FontFamily.SFProText.semibold.font(size: 17.0)
		return label
	}()
	
	private let xpPointsTextfield: UITextField = {
		let textfield = UITextField()
		textfield.layer.cornerRadius = 12.0
		textfield.backgroundColor = Assets.Colors.pickerViewGrey.color
		return textfield
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
		let button = makeRoundedButton()
		button.setTitle("Done", for: .normal)
		return button
	}()
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		setupUI()
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
		
		view.addSubview(nameTextfield)
		nameTextfield.snp.makeConstraints { make in
			make.top.equalTo(setNameLabel.snp.bottom).offset(6.0)
			make.height.equalTo(42.0)
			make.right.left.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(setXPPointsLabel)
		setXPPointsLabel.snp.makeConstraints { make in
			make.top.equalTo(nameTextfield.snp.bottom).offset(12.0)
			make.right.left.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(xpPointsTextfield)
		xpPointsTextfield.snp.makeConstraints { make in
			make.top.equalTo(setXPPointsLabel.snp.bottom).offset(6.0)
			make.height.equalTo(42.0)
			make.left.right.equalToSuperview().inset(16.0)
		}
		
		view.addSubview(pickAssigneeLabel)
		pickAssigneeLabel.snp.makeConstraints { make in
			make.top.equalTo(xpPointsTextfield.snp.bottom).offset(42.0)
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
			make.bottom.equalToSuperview().inset(24.0)
		}
	}
}
