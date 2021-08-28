//
//  UserSession.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 28/08/2021.
//

import Foundation

struct UserSession: Codable {
	let token: String
	let user: User
}
