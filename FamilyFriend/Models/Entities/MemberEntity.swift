//
//  Member.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 27/07/2021.
//

import Foundation

struct MemberEntity: Codable, Equatable {
	let id: UUID
	let family: _Family
	let name: String
	
	struct _Family: Codable, Equatable {
		let id: UUID
	}
	
	init(from member: Member) {
		self.id = member.id
		self.family = .init(id: member.familyId)
		self.name = member.name
	}
}

