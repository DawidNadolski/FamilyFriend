//
//  Member.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 27/07/2021.
//

import Foundation

struct Member: Codable, Equatable {
	let id: UUID
	let familyId: UUID
	let name: String
}
