//
//  Family.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import Foundation

struct Family: Codable, Equatable {
	let id: UUID
	let name: String
	let password: String
}
