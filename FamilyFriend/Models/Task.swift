//
//  Task.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 31/07/2021.
//

import Foundation

struct Task: Codable {
	let taskID: UUID?
	let name: String
	let xpPoints: Int
	let executingMemberID: Int?
	let completed: Bool
}
