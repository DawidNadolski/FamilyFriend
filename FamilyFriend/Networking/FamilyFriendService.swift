//
//  FamilyFriendService.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 21/08/2021.
//

import RxSwift

protocol FamilyFriendAPI {
	func getMembers() -> Observable<[Member]>
	func getTasks() -> Observable<[Task]>
	func saveTask(_ task: Task)
	func getShoppingLists() -> Observable<[ShoppingList]>
	func saveShoppingList(_ list: ShoppingList)
	func deleteShoppingList(_ list: ShoppingList)
	func getShoppingListComponents() -> Observable<[ShoppingListComponent]>
	func saveShoppingListComponent(_ component: ShoppingListComponent)
	func deleteShoppingListComponent(_ component: ShoppingListComponent)
}

final class FamilyFriendService: FamilyFriendAPI {
	
	private let client: APIClient

	init(client: APIClient = APIClient()) {
		self.client = client
	}
	
	func getMembers() -> Observable<[Member]> {
		return client.send(apiRequest: GetMembersRequest())
	}
	
	func getTasks() -> Observable<[Task]> {
		return client.send(apiRequest: GetTasksRequest())
	}
	
	func saveTask(_ task: Task) {
		client.send(apiRequest: SaveTaskRequest(), body: task)
	}
	
	func getShoppingLists() -> Observable<[ShoppingList]> {
		return client.send(apiRequest: GetShoppingListsRequest())
	}
	
	func saveShoppingList(_ list: ShoppingList) {
		client.send(apiRequest: SaveShoppingListRequest(), body: list)
	}
	
	func deleteShoppingList(_ list: ShoppingList) {
		client.send(apiRequest: DeleteShoppingListRequest(), body: list)
	}
	
	func getShoppingListComponents() -> Observable<[ShoppingListComponent]> {
		return client.send(apiRequest: GetShoppingListComponentsRequest())
	}
	
	func saveShoppingListComponent(_ component: ShoppingListComponent) {
		client.send(apiRequest: SaveShoppingListComponentRequest(), body: component)
	}
	
	func deleteShoppingListComponent(_ component: ShoppingListComponent) {
		client.send(apiRequest: DeletingShoppingListComponentRequest(), body: component)
	}
}
