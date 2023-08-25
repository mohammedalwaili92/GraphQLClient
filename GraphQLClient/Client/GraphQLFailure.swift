//
//  GraphQLFailure.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

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
