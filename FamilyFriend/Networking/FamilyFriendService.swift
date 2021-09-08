//
//  FamilyFriendService.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 21/08/2021.
//

import RxSwift

protocol FamilyFriendAPI {
	func signUp(with userCredentials: UserCredentials, completion: @escaping CompletionHandler<UserSession>)
	func signIn(with userCredentials: UserCredentials, completion: @escaping CompletionHandler<UserSession>)
	func getMembers() -> Observable<[MemberEntity]>
	func saveMember(_ member: Member)
	func deleteMember(_ member: Member)
	func getFamilies() -> Observable<[Family]>
	func saveFamily(_ family: Family)
	func getTasks() -> Observable<[TaskEntity]>
	func saveTask(_ task: Task)
	func completeTask(_ task: Task)
	func deleteTask(_ task: Task)
	func getShoppingLists() -> Observable<[ShoppingListEntity]>
	func saveShoppingList(_ list: ShoppingList)
	func deleteShoppingList(_ list: ShoppingList)
	func getShoppingListComponents() -> Observable<[ShoppingListComponentEntity]>
	func saveShoppingListComponent(_ component: ShoppingListComponent)
	func deleteShoppingListComponent(_ component: ShoppingListComponent)
}

final class FamilyFriendService: FamilyFriendAPI {
	
	private let client: APIClient

	init(client: APIClient = APIClient()) {
		self.client = client
	}
	
	func signUp(with userCredentials: UserCredentials, completion: @escaping CompletionHandler<UserSession>) {
		client.send(apiRequest: SignUpRequest(), body: userCredentials, completion: completion)
	}
	
	func signIn(with userCredentials: UserCredentials, completion: @escaping CompletionHandler<UserSession>) {
		client.send(apiRequest: SignInRequest(), body: userCredentials, completion: completion, isAuthenticated: true)
	}
	
	func getFamilies() -> Observable<[Family]> {
		client.send(apiRequest: GetFamiliesRequest())
	}
	
	func saveFamily(_ family: Family) {
		client.send(apiRequest: SaveFamilyRequest(), body: family)
	}
	
	func getMembers() -> Observable<[MemberEntity]> {
		return client.send(apiRequest: GetMembersRequest())
	}
	
	func saveMember(_ member: Member) {
		let entity = MemberEntity(from: member)
		client.send(apiRequest: SaveMemberRequest(), body: entity)
	}
	
	func deleteMember(_ member: Member) {
		let entity = MemberEntity(from: member)
		client.send(apiRequest: DeleteMemberRequest(), body: entity)
	}
	
	func getTasks() -> Observable<[TaskEntity]> {
		return client.send(apiRequest: GetTasksRequest())
	}
	
	func saveTask(_ task: Task) {
		let entity = TaskEntity(from: task)
		client.send(apiRequest: SaveTaskRequest(), body: entity)
	}
	
	func completeTask(_ task: Task) {
		let entity = TaskEntity(from: task)
		client.send(apiRequest: CompleteTaskRequest(), body: entity)
	}
	
	func deleteTask(_ task: Task) {
		let entity = TaskEntity(from: task)
		client.send(apiRequest: DeleteTaskRequest(), body: entity)
	}
	
	func getShoppingLists() -> Observable<[ShoppingListEntity]> {
		return client.send(apiRequest: GetShoppingListsRequest())
	}
	
	func saveShoppingList(_ list: ShoppingList) {
		let entity = ShoppingListEntity(from: list)
		client.send(apiRequest: SaveShoppingListRequest(), body: entity)
	}
	
	func deleteShoppingList(_ list: ShoppingList) {
		let entity = ShoppingListEntity(from: list)
		client.send(apiRequest: DeleteShoppingListRequest(), body: entity)
	}
	
	func getShoppingListComponents() -> Observable<[ShoppingListComponentEntity]> {
		return client.send(apiRequest: GetShoppingListComponentsRequest())
	}
	
	func saveShoppingListComponent(_ component: ShoppingListComponent) {
		let entity = ShoppingListComponentEntity(from: component)
		client.send(apiRequest: SaveShoppingListComponentRequest(), body: entity)
	}
	
	func deleteShoppingListComponent(_ component: ShoppingListComponent) {
		let entity = ShoppingListComponentEntity(from: component)
		client.send(apiRequest: DeletingShoppingListComponentRequest(), body: entity)
	}
}
