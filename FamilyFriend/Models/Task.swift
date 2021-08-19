//
//  Task.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 31/07/2021.
//

import Foundation

struct Task: Codable {
	let taskID: Int
	let name: String
	let description: String?
	let xpPoints: Int
	let executingMemberID: Int?
	let assignmentDate: Date?
	let dueDate: Date?
	let completed: Bool
}
