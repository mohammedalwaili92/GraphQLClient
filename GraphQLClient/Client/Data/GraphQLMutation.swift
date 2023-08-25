//
//  GraphQLMutation.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

protocol GraphQLMutation: GraphQLOperation {
    var mutation: String { get }
}
