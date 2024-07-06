//
//  NetworkHandler.swift
//  MovieDBList
//
//  Created by Sharon Omoyeni Babatunde on 02/07/2024.
//

import Foundation
import Combine

public class NetworkHandler: NetworkHandling {
    
    private let session: URLSession
    private var apiKey: String?
    
    public init(session: URLSession = .shared, apiKey: String? = nil) {
        self.session = session
        self.apiKey = apiKey
    }
    
    public func request<T: Decodable>(with urlString: String,
                               method: HTTPMethod? = .GET,
                               body: Data? = nil,
                               headers: [String: String]? = nil,
                               completion: @escaping (Result<T, Error>) -> Void) {
        guard var components = URLComponents(string: urlString) else {
            Logger.printIfDebug(data: "Invalid URL string", logType: .error)
            return
        }
        
        if let apiKey {
            components.queryItems = components.queryItems ?? []
            components.queryItems?.append(URLQueryItem(name: "api_key", value: apiKey))
        }
        guard let urlWithApiKey = components.url else {
            completion(.failure(NSError(domain: "NetworkHandler", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: urlWithApiKey)
        request.httpMethod = method?.rawValue
        request.httpBody = body
        Logger.printIfDebug(data: "URL: \(urlWithApiKey)", logType: .info)
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                Logger.printIfDebug(data: "Error: \(error)", logType: .error)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NetworkHandler", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                Logger.printIfDebug(data: "Error: \(error)", logType: .error)
                completion(.failure(error))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                Logger.printIfDebug(data: "Successful Response: \(decodedObject)", logType: .success)
                completion(.success(decodedObject))
            } catch {
                Logger.printIfDebug(data: "Error: \(error)", logType: .error)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func fetchImage(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.cannotDecodeContentData)))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
     
}
