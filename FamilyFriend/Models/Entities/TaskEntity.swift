//
//  TaskEntity.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 01/09/2021.
//

import Foundation

struct TaskEntity: Codable, Equatable {
	let id: UUID
	let name: String
	let xpPoints: Int
	let assignedMember: _Member
	let assignedMemberName: String
	var completed: Bool
	
	struct _Member: Codable, Equatable {
		let id: UUID
	}
	
	init(from task: Task) {
		self.id = task.id
		self.name = task.name
		self.xpPoints = task.xpPoints
		self.assignedMember = .init(id: task.assignedMemberId)
		self.assignedMemberName = task.assignedMemberName
		self.completed = task.completed
	}
}
