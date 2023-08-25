//
//  GraphQLClient.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import Foundation

protocol GraphQLClient {
    func fetch<T: Decodable>(query: GraphQLQuery) async throws -> T
    func perform<T: Decodable>(mutation: GraphQLMutation) async throws -> T
}

enum GraphQLClientError: Error {
    case invalidURL
    case invalidArguments
}

private let gatewayURL = URL(string: "https://integration-gateway.action.com/api/gateway")!

private let graphQLInterceptors: [GraphQLRequestInterceptor] = [
    GraphQLTokenRequestInterceptor(token: token),
    GraphQLDefaultRequestInterceptor()
]

final class GraphQLClientImp: GraphQLClient {
    
    private let baseURL: URL
    private let interceptors: [GraphQLRequestInterceptor]
    private let session: URLSession
    
    init(baseURL: URL = gatewayURL,
         interceptors: [GraphQLRequestInterceptor] = graphQLInterceptors) {
        self.baseURL = baseURL
        self.interceptors = interceptors
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        self.session = URLSession(configuration: configuration)
    }
    
    func fetch<T>(query: GraphQLQuery) async throws -> T where T : Decodable {
        let (data, _) = try await session.data(for: try makeRequest(for: query))
        if let failure = try? JSONDecoder().decode(GraphQLFailure.self, from: data),
           failure.errors.contains(where: { $0.message == "PersistedQueryNotFound" }) {
            let (data, _) = try await session.data(for: try makeRequest(for: query, includeQuery: true))
            return try JSONDecoder().decode(T.self, from: data)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func perform<T>(mutation: GraphQLMutation) async throws -> T where T : Decodable {
        let (data, _) = try await session.data(for: try makeRequest(for: mutation))
        print(String(data: data, encoding: .utf8)!)
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
        for interceptor in interceptors {
            interceptor.intercept(request: &request, operation: query)
        }
        return request
    }
    
    func makeRequest(for mutation: GraphQLMutation) throws -> URLRequest {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        
        var body: [String: Any] = [:]
        body["query"] = mutation.mutation
        if let variables = mutation.variables {
            body["variables"] = variables
        }
        request.httpBody = try JSONSerialization.data(withJSONObject: body)
        
        for interceptor in interceptors {
            interceptor.intercept(request: &request, operation: mutation)
        }
        return request
    }
}
