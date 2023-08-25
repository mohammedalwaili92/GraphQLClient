//
//  UpdateUserData.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import Foundation

struct UpdateUserDataMutation: GraphQLMutation {
    
    let operationName: String = "UpdateUserData"
    let variables: [String : Any]?
    
    var isAuthorized: Bool { true }
    
    let mutation: String = """
        mutation UpdateUserData($firstName: String!, $lastName: String!, $dob: String!) {
          updateUserData(firstName: $firstName, lastName: $lastName, dob: $dob) {
            success
          }
        }
    """
    
    init(firstName: String) {
        self.variables = [
            "firstName": firstName,
            "lastName": "Al Waili",
            "dob": "1992-07-10"
        ]
    }
}
