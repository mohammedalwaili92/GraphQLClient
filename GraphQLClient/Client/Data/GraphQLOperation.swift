//
//  GraphQLOperation.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

protocol GraphQLOperation {
    var operationName: String { get }
    var variables: [String: Any]? { get }
    var isAuthorized: Bool { get }
}

extension GraphQLOperation {
    
    var isAuthorized: Bool { false }
}
