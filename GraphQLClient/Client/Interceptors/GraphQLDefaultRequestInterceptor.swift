//
//  GraphQLDefaultRequestInterceptor.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

final class GraphQLDefaultRequestInterceptor: GraphQLRequestInterceptor {
    
    func intercept(request: inout URLRequest, operation: GraphQLOperation) {
        request.setValue("nl-NL", forHTTPHeaderField: "Accept-Language")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    }
}
