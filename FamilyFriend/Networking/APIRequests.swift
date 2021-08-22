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
	var parameters: [String : String] { get }
}

public enum RequestType: String {
	case GET
	case POST
}

extension APIRequest {
	
	func request(with baseURL: URL) -> URLRequest {
		guard var components = URLComponents(
			url: baseURL.appendingPathComponent(path),
			resolvingAgainstBaseURL: false)
		else {
			fatalError("Unable to create URL components")
		}
		
		components.queryItems = parameters.map {
			URLQueryItem(name: $0, value: $1)
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

final class GetTasksRequest: APIRequest {
	
	var method: RequestType = .GET
	var path: String = "tasks"
	var parameters: [String : String] = [:]
}

final class SaveTaskRequest: APIRequest {
	
	var method: RequestType = .POST
	var path: String = "task"
	var parameters: [String : String] = [:]
}


