//
//  ShoppingListEntity.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 01/09/2021.
//

import Foundation

struct ShoppingListEntity: Codable, Equatable {
	let id: UUID
	let family: _Family
	let name: String
	
	struct _Family: Codable, Equatable {
		let id: UUID
	}
	
	init(from list: ShoppingList) {
		self.id = list.id
		self.family = .init(id: list.familyId)
		self.name = list.name
	}
}
