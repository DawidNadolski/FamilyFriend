//
//  ShoppingListComponent.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 05/08/2021.
//

import Foundation

struct ShoppingListComponentEntity: Codable, Equatable {
	let id: UUID
	let shoppingList: _ShoppingList
	let name: String
	
	struct _ShoppingList: Codable, Equatable {
		let id: UUID
	}
	
	init(from component: ShoppingListComponent) {
		self.id = component.id
		self.shoppingList = .init(id: component.listId)
		self.name = component.name
	}
}
