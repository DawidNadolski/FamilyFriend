//
//  Member.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 01/09/2021.
//

import Foundation

struct Member: Codable, Equatable {
	let id: UUID
	let familyId: UUID
	let name: String
}

extension Member {
	init(from entity: MemberEntity) {
		self.id = entity.id
		self.familyId = entity.family.id
		self.name = entity.name
	}
}

