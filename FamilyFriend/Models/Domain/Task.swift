//
//  Task.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 31/07/2021.
//

import Foundation

struct Task: Codable, Equatable {
	let id: UUID
	let name: String
	let xpPoints: Int
	let assignedMemberId: UUID
	let assignedMemberName: String
	var completed: Bool
}

extension Task {
	init(from entity: TaskEntity) {
		self.id = entity.id
		self.name = entity.name
		self.xpPoints = entity.xpPoints
		self.assignedMemberId = entity.assignedMember.id
		self.assignedMemberName = entity.assignedMemberName
		self.completed = entity.completed
	}
}
