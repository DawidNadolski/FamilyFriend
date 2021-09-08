//
//  ShoppingList.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 05/08/2021.
//

import Foundation

struct ShoppingList: Codable, Equatable {
	let id: UUID
	let familyId: UUID
	let name: String
}

extension ShoppingList {
	init(from entity: ShoppingListEntity) {
		self.id = entity.id
		self.familyId = entity.family.id
		self.name = entity.name
	}
}
