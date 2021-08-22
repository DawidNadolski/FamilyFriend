//
//  FamilyFriendService.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 21/08/2021.
//

import RxSwift

protocol FamilyFriendAPI {
	func getTasks() -> Observable<[Task]>
	func saveTask(task: Task)
}

final class FamilyFriendService: FamilyFriendAPI {
	
	private let client: APIClient

	init(client: APIClient = APIClient()) {
		self.client = client
	}
	
	func getTasks() -> Observable<[Task]> {
		return client.send(apiRequest: GetTasksRequest())
	}
	
	func saveTask(task: Task) {
		client.send(apiRequest: SaveTaskRequest(), body: task)
	}
}
