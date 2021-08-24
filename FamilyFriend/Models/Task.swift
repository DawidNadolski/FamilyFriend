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
	let executingMemberId: UUID
	let executingMemberName: String
	let completed: Bool
}
