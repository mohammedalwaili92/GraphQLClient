//
//  GraphQLClient.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import Foundation
import CryptoKit

struct TestObject: Decodable { }

protocol RequestHeaderProviding {
    func provide() -> [String: String]
}

final class RequestTokenHeaderProvider: RequestHeaderProviding {
    func provide() -> [String : String] {
        let token = "eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwidHlwIjoiSldUIn0.au3KZoYK-wd_qJOrmjCLv3YJDWWMJCI3tLFCLqleSKITNza9Liq8uHOG2MJJf_GhXCOYeY3Gze2cpoTa_PR-72a9iNwMKaau.B_ejKgh4b-s-5rQ_uYWeZw.Ia--CbZrTvGjJtrHf2FHgk1ybl8lsRiMtS5DV4cLZ1DtMQfYChkQ-1BBUhsdu_im7bZ-kliQo_c8LDdOcJbw367iXV0tA5SUunfRHJ9f5fn5cAo4TMcrRHoFe7mCubEGChGcKPPbMzey_i9PTFAgnDVHIhDP-gPsp7wuYK24ALvOkl3zilK3YAlHSDnQPsi1-JUG7P3O4lynbBT_wXCkeXBxKFQeBrQrXQ7wAArz41XxV2slcMQvEugcA8yJI1V9BkxAwHTqoOGT62DNNNjyLrGK5fwlH04_Sa8E_l9uav5bF5aeRX5T6gZVjomTCDiGhPJYzaRTwAiY_ysinFNTX1OX-1JC96r0EnqYrYV0VX-LlUWk2snIyWt2OczIjBG9mMDu6bGVrYjOJRIj2YNe0hrXj-EgTOU2JoY5W8qANW6sVJFVzyDyVruz2xTPHIEPF93iMClRm4auhI5dvHfhc_DcDA6NJOaRPqaafC1qNA0G7Uc_hllSZO8JBRgVKpAZ57vlgIxb2sQtEfUG6OUEjH-BPZppgHBeuqAozWPAqGASbtLJm5nPlYsExxZsGGdKz80KRoEMm_g05PZW5GIhAB1v48r81E8DZzyoUIGJiDOEovjAA1SJ7hq68keoqqYB4f6W0qVPRdg6K7SuHPGUVPBes6FqwkNLJyWOplkWH-FS3GJaXMChVCxsK9jj-2aDQ7nm5Hj3zEQyh1cIuaehy40yTv7anWN0JXGXPEiTjaCX9klklKvcceyvm-1Ybz21lIazyrppkv0QkY4Z2jUGoA.8Lzb58t-e7rCAqpcK-T6AQhhFEUHvnmY-OMuJSGgdVM"
        return ["Authorization": "Bearer \(token)"]
    }
}

final class GraphQLURLQueryBuilder {
    
    var body: [String: Any] = [:]
    
    func add(query: [String: Any]) -> Self {
        body.merge(query) { current, _ in current }
        return self
    }
    
    func add(operationName: String = "GetStores") -> Self {
        body["operationName"] = operationName
        
        return self
    }
    
    func build() -> [String: Any] {
        
//        let data = try! JSONSerialization.data(withJSONObject: body)
        let data = (body["query"] as! String).data(using: .utf8)!
        let hash = sha256(data: data)

        body["extensions"] = [
            "persistedQuery":
                [
                    "headers": [
                        "Accept-Language": "nl-NL"
                    ],
                    "sha256Hash": hash,
                    "version": 1,
                ]
        ]
//
//        var sha = [String: Any]()
//        sha["extensions"] = [
//            "persistedQuery": [
//                "sha256Hash": hash
//            ]
//        ]

//        let mergedBody = body.merging(sha) { current, _ in
//            current
//        }
//
        print(body)
        
        return body
    }
    
    func sha256(data: Data) -> String {
        let hashed = SHA256.hash(data: data)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}

protocol GraphQLClient {
    
    func makeRequest(params: [String: Any]) throws -> URLRequest
    func fetch<T: Decodable>(request: URLRequest) async throws -> T
    func mutate<T: Decodable>(request: URLRequest) async throws -> T
}

final class GraphQLClientImp: GraphQLClient {
    
    private let baseURL = URL(string: "https://integration-gateway.action.com/api/gateway")!

    func makeRequest(params: [String: Any]) throws -> URLRequest {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        
        urlComponents.queryItems = params.map {
            if let stringValue = $0.value as? String {
                return URLQueryItem(name: $0.key, value: stringValue)
            }
            print(params)
            let data = try! JSONSerialization.data(withJSONObject: $0.value)
            let stringValue = String(data: data, encoding: .utf8)
            print(stringValue)
            return URLQueryItem(name: $0.key, value: stringValue)
        }
        
        var request = URLRequest(url: urlComponents.url!)
        print(urlComponents.url!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        return request
    }
    
    func fetch<T: Decodable>(request: URLRequest) async throws -> T {
        let session = URLSession.shared
        let (data, _) = try await session.data(for: request)
        print(String(data: data, encoding: .utf8))
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func mutate<T>(request: URLRequest) async throws -> T where T : Decodable {
        let session = URLSession.shared
        let (data, _) = try await session.data(for: request)
        print(String(data: data, encoding: .utf8))
        return try JSONDecoder().decode(T.self, from: data)
    }
}
