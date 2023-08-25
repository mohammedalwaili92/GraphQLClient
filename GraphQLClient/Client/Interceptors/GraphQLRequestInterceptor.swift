//
//  GraphQLRequestInterceptor.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

protocol GraphQLRequestInterceptor {
    func intercept(request: inout URLRequest, operation: GraphQLOperation)
}
