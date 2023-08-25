//
//  GetStoresQuery.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import Foundation

struct GetStoresQuery: GraphQLQuery {    
    let operationName = "GetStores"
    var variables: [String : Any]?
    
    init(place: String) {
        variables = [
            "input": [
                "query": place
            ]
        ]
    }
    
    var query: String {
      """
      query GetStores($input: SearchInput) {
        storeSearchV2(input: $input) {
          __typename
          ...storeInfoFields
        }
      }
      \(StoreInfoFieldsFragment())
      """
    }
}
