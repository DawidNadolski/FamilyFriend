//
//  APIClient.swift
//  FamilyFriend
//
//  Created by Dawid Nadolski on 21/08/2021.
//

import RxSwift

enum NetworkError: Error {
	case responsError
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
}

extension APIClient {
	
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
	
	func send(apiRequest: APIRequest, body: UserCredentials, completion: @escaping CompletionHandler<UserSession>, isAuthenticated: Bool = false) {
		var urlRequest = apiRequest.request(with: baseURL)
		urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		if isAuthenticated {
			let loginString = String(format: "%@:%@", body.username, body.password)
			let loginData = loginString.data(using: String.Encoding.utf8)!
			let base64LoginString = loginData.base64EncodedString()

			urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
		} else {
			guard let encodedBody = try? JSONEncoder().encode(body) else {
				completion(.failure(NetworkError.jsonEncodingError))
				return
			}
			urlRequest.httpBody = encodedBody
		}
		
		let dataTask = URLSession.shared
			.dataTask(with: urlRequest) { data, response, _ in
				if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
					print("Status code: \(httpResponse.statusCode)")
					completion(.failure(NetworkError.responsError))
					return
				}
				
				guard let jsonData = data else {
					completion(.failure(NetworkError.malformedResponseData))
					return
				}

				do {
					let session = try JSONDecoder().decode(UserSession.self, from: jsonData)
					completion(.success(session))
				} catch {
					completion(.failure(NetworkError.jsonDecodingError))
				}
			}
		dataTask.resume()
	}
}
