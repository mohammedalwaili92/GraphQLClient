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


//let fragment = """
//    fragment storeInfoFields on StoreV2 {
//      __typename
//      id
//      name
//      address {
//        __typename
//        street
//        houseNumber
//        houseNumberExtra
//        postalCode
//        city
//      }
//      openingDays {
//        __typename
//        dayName
//        description
//        closed
//        openingHour {
//          __typename
//          openFrom
//          openUntil
//        }
//      }
//    }
//    """
//
//func GetStoresQuery(place: String) -> [String: Any] {
//    let query =
//      """
//      query GetStores($input: SearchInput) {
//        storeSearchV2(input: $input) {
//          __typename
//          ...storeInfoFields
//        }
//      }
//      \(fragment)
//      """
//
//    let variables: [String : Any] =
//        [
//            "input": [
//                "query": place,
//                "analyticsTags": ["app-iOS"]
//            ]
//        ]
//
//     return ["query": query, "variables": variables]
//}

