//
//  GraphQLURLQueryBuilder.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

final class GraphQLURLQueryBuilder {
    
    private let includeQuery: Bool
    
    init(includeQuery: Bool) {
        self.includeQuery = includeQuery
    }
    
    func build(from query: GraphQLQuery) throws -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        items.append(URLQueryItem(name: "operationName", value: query.operationName))
        if let variables = query.variables {
            items.append(URLQueryItem(name: "variables", value: try variables.jsonString()))
        }
        let persistedQuery: [String: Any] = [
            "persistedQuery": [
                "headers": [
                    "Accept-Language": "nl-NL"
                ],
                "sha256Hash": query.hash,
                "version": 1
            ] as [String : Any]
        ]
        items.append(URLQueryItem(name: "extensions", value: try persistedQuery.jsonString()))
        if includeQuery {
            items.append(URLQueryItem(name: "query", value: query.query))
        }
        return items
    }
}

extension Dictionary where Key == String, Value == Any {
    
    func jsonString() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        guard let stringValue = String(data: data, encoding: .utf8) else {
            throw GraphQLClientError.invalidArguments
        }
        return stringValue
    }
}
