//
//  GraphQLQuery.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation
import CryptoKit

protocol GraphQLQuery: GraphQLOperation {
    var query: String { get }
    var hash: String { get }
}

extension GraphQLQuery {
    
    var hash: String {
        guard let data = query.data(using: .utf8) else {
            return ""
        }
        return sha256(data: data)
    }
    
    private func sha256(data: Data) -> String {
        let hashed = SHA256.hash(data: data)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}
