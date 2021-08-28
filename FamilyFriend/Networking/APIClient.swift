//
//  APIClient.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 21/08/2021.
//

import RxSwift

enum NetworkError: Error {
	case malformedResponseData
	case jsonEncodingError
	case jsonDecodingError
}

typealias CompletionHandler<T> = (Result<T, Error>) -> Void

final class APIClient {
	
	private let baseURL: URL
	
	init(baseURL: URL = URL(string: "http://localhost:8080/")!) {
		self.baseURL = baseURL
	}
		
	func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
		let request = apiRequest.request(with: baseURL)
		return URLSession.shared.rx.data(request: request)
			.map { data in
				return try JSONDecoder().decode(T.self, from: data)
			}
			.observeOn(MainScheduler.asyncInstance)
	}
	
	func send<T: Codable>(apiRequest: APIRequest, body: T) where T: Equatable {
		var request = apiRequest.request(with: baseURL)
		
		let encoder = JSONEncoder()
		guard let data = try? encoder.encode(body) else {
			print(NetworkError.jsonEncodingError.localizedDescription)
			return
		}
		
		request.httpBody = data
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			if let data = data {
				let decoder = JSONDecoder()
				if let item = try? decoder.decode(T.self, from: data) {
					if item != body {
						print(NetworkError.malformedResponseData.localizedDescription)
					}
				} else {
					print(NetworkError.jsonDecodingError.localizedDescription)
				}
			}
		}
		.resume()
	}
	
	func send(apiRequest: APIRequest, body: UserCredentials, completion: @escaping CompletionHandler<UserSession>) {
		var request = apiRequest.request(with: baseURL)
		
		let encoder = JSONEncoder()
		guard let data = try? encoder.encode(body) else {
			completion(.failure(NetworkError.jsonEncodingError))
			return
		}
		
		request.httpBody = data
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			if let error = error {
				completion(.failure(error))
			} else {
				if let data = data {
					let decoder = JSONDecoder()
					if let item = try? decoder.decode(UserSession.self, from: data) {
						completion(.success(item))
					} else {
						completion(.failure(NetworkError.jsonDecodingError))
					}
				} else {
					completion(.failure(NetworkError.malformedResponseData))
				}
			}
		}
	}
}
