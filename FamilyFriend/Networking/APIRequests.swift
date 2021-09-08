//
//  APIRequests.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 21/08/2021.
//

import Foundation

protocol APIRequest {
	var method: RequestType { get }
	var path: String { get }
}

public enum RequestType: String {
	case GET
	case POST
}

extension APIRequest {
	
	func request(with baseURL: URL) -> URLRequest {
		guard let components = URLComponents(
			url: baseURL.appendingPathComponent(path),
			resolvingAgainstBaseURL: false)
		else {
			fatalError("Unable to create URL components")
		}
		
		guard let url = components.url else {
			fatalError("Couldn't get url")
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		
		if method == .GET {
			request.setValue("application/json", forHTTPHeaderField: "Accept")
		} else if method == .POST {
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		}
		
		return request
	}
}

final class SignUpRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "users/signup"
}

final class SignInRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "users/login"
}

final class GetFamiliesRequest: APIRequest {
	var method: RequestType = .GET
	var path: String = "families"
}

final class SaveFamilyRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "family"
}

final class GetMembersRequest: APIRequest {
	
	var method: RequestType = .GET
	var path: String = "members"
}

final class SaveMemberRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "member"
}

final class DeleteMemberRequest: APIRequest {
	var method: RequestType = .POST
	var path: String = "deleteMember"
}

final class GetTasksRequest: APIRequest {
	
	var method: RequestType = .GET
	var path: String = "tasks"
}

final class SaveTaskRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "task"
}

final class CompleteTaskRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "completeTask"
}


final class DeleteTaskRequest: APIRequest {
	var method: RequestType = .POST
	var path: String = "deleteTask"
}

final class GetShoppingListsRequest: APIRequest {
	
	var method: RequestType = .GET
	var path: String = "shoppingLists"
}

final class SaveShoppingListRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "shoppingList"
}

final class DeleteShoppingListRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "deleteShoppingList"
}

final class GetShoppingListComponentsRequest: APIRequest {
	
	var method: RequestType = .GET
	var path: String = "shoppingListComponents"
}

final class SaveShoppingListComponentRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "shoppingListComponent"
}

final class DeletingShoppingListComponentRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "deleteShoppingListComponent"
}

