//
//  GraphQLTokenRequestInterceptor.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

final class GraphQLTokenRequestInterceptor: GraphQLRequestInterceptor {
    
    private let token: String
    
    init(token: String) {
        self.token = token
    }
    
    func intercept(request: inout URLRequest, operation: GraphQLOperation) {
        if operation.isAuthorized {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
}
