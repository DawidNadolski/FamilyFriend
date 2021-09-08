//
//  User.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import Foundation

struct User: Codable {
	let username: String
	let id: UUID
	let updatedAt: String
	let createdAt: String
}
