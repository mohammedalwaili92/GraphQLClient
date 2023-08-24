//
//  UpdateUserData.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import Foundation

struct UpdateUserDataResponse: Decodable {
    let success: Bool
}

func UpdateUserDataMutation(firstName: String) -> [String: Any] {
    let mutation = """
        mutation UpdateUserData(
            $firstName: String!
            $lastName: String!
            $dob: String!
        ) {
            updateUserData(firstName: $firstName, lastName: $lastName, dob: $dob) {
                success
            }
        }
    """
    let variables: [String : Any] = ["firstName": firstName, "lastName": "Al Waili", "dob": "1992-07-10"]
    
    return ["query": mutation, "variables": variables]
}
