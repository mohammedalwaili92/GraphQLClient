//
//  GraphQLClient.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import Foundation

protocol GraphQLClient {
    func fetch<T: Decodable>(query: GraphQLQuery) async throws -> T
    func mutate<T: Decodable>(request: URLRequest) async throws -> T
}

enum GraphQLClientError: Error {
    case invalidURL
    case invalidArguments
}

struct GraphQLErrorExtensions: Decodable {
    let code: String
}

struct GraphQLError: Decodable {
    let message: String
    let extensions: GraphQLErrorExtensions
}

struct GraphQLFailure: Decodable {
    let errors: [GraphQLError]
}

final class GraphQLClientImp: GraphQLClient {
    
    private let baseURL = URL(string: "https://integration-gateway.action.com/api/gateway")!
    
    func fetch<T>(query: GraphQLQuery) async throws -> T where T : Decodable {
        let session = URLSession.shared
        let (data, _) = try await session.data(for: try makeRequest(for: query))
        
        if let failure = try? JSONDecoder().decode(GraphQLFailure.self, from: data),
           failure.errors.contains(where: { $0.message == "PersistedQueryNotFound" }) {
            let (data, _) = try await session.data(for: try makeRequest(for: query, includeQuery: true))
            print(String(data: data, encoding: .utf8)!)
            return try JSONDecoder().decode(T.self, from: data)
        }
        
        print(String(data: data, encoding: .utf8)!)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // TODO: update this
    func mutate<T>(request: URLRequest) async throws -> T where T : Decodable {
        let session = URLSession.shared
        let (data, _) = try await session.data(for: request)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

private extension GraphQLClientImp {
    
    func makeRequest(for query: GraphQLQuery, includeQuery: Bool = false) throws -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        
        let queryItems = try GraphQLURLQueryBuilder(includeQuery: includeQuery).build(from: query)
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw GraphQLClientError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
