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

private let token = """
eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwidHlwIjoiSldUIn0.e2N_I8ALLnWNaV44caxD1BgtBpIyy6RMuuoVUA9JfTzo69Q449GcaBG-e-dqzO9hJqZUNhvZAdVGHKvuPT0HHMohyGynbXA3.MGq14tdmWVvmTKurB4_olQ.WiEvbNsM-gZIKmQZeuFkRg3Ohn_4DZWJCTY5Atoeimc4P_Xo6rtKVSTmS3aHFhU6QDXZtizWJNlSLZiB0iVZJzcdgGM86YkhfUSvGv5hL6lMUvq6nCdmomoFeMeaob_4_TsoI4Zy-MJuyQipRuCpthwHtK_KNlnG6W_zZO6yWO8-i_Q_BIgr2QHI0CAG74hxLTTCyYSsxhphVwcPwA3v67D-_FPMpBWSou8Y2eTYNGv-0TtosKW53TBG8K-YbA5fEsxJHRm-RxZ8AFUElL6F0RaglKYSsJcWJGIXCenNs6dStU2NtVj3ISaXGE5eyvyjkHnHx_FI13xq-SvBmZeqGiHzrhk4FhUUQz0AgP1Xlxy-uP7NSmUBmzpBK67LyAmzAkhbEm7xvxEt66QTDGbTv2Gme5nMpAUyOL5pJpdchXwl4_s02R_ibUO89xVraAveCN6fsxwYwZxdT9fN7I2U4i58ptbcIuuqFkv_Qdm7jG76OX6Ifb1_HkfkrwrLpiGNkG3U7gZNNAYcP9fbA8FgQ8y1aCO_EJoHEdOO5ZEX48fNcKM6LdEqwzYde-G6cwiY1WTqsAjKOHnoWjcsNMIzYESWUtE4s5XBd0apUhKtfxrN9dglipZSKOQ4i0jakVCPtY9sQI6x5ikOCvBqB91HDQBhC2br_aGYyDLRnuFTDIKXnIqvDN2H8PKESp3D3MsfAUoK3lLnrEIYlO0Z6XRu1glpIROPilXCSq_tzoQv5cu5uOBn2dYa8dbymybu3b-4Uy5m6OFAhnhnvsk7Mvd67w.5Qk3m_PE7IZMhzvlEwfnmGuz2d4GflteX-4tXnHkbgM
"""

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
