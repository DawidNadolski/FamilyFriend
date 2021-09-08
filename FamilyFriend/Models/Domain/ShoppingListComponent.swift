//
//  ShoppingListComponent.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 01/09/2021.
//

import Foundation

struct ShoppingListComponent: Codable, Equatable {
	let id: UUID
	let listId: UUID
	let name: String
}

extension ShoppingListComponent {
	init(from entity: ShoppingListComponentEntity) {
		self.id = entity.id
		self.listId = entity.shoppingList.id
		self.name = entity.name
	}
}
