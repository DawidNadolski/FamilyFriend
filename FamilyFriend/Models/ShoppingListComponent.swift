//
//  ShoppingListComponent.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 05/08/2021.
//

import Foundation

struct ShoppingListComponent: Codable, Equatable {
	let id: UUID
	let listId: UUID
	let name: String
}
