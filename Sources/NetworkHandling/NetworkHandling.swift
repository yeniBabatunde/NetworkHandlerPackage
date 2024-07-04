//
//  NetworkHandling.swift
//  MovieDBList
//
//  Created by Sharon Omoyeni Babatunde on 02/07/2024.
//

import Foundation

public protocol NetworkHandling {
    func request<T: Decodable>(with urlString: String,
                               method: HTTPMethod?,
                               body: Data?,
                               headers: [String: String]?,
                               completion: @escaping (Result<T, Error>) -> Void)
    
    func fetchImage(urlString: String, completion: @escaping (Result<Data, Error>) -> Void)
}
