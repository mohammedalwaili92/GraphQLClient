//
//  GetStoresQuery.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import Foundation

let fragment = """
fragment storeInfoFields on StoreV2 { id name address { street } openingDays { dayName description closed openingHour { openFrom openUntil } } }
"""

func GetStoresQuery(place: String) -> [String: Any] {
    let query = """
      StoreSearchV2($input: SearchInput) { storeSearchV2(input: $input) { ...storeInfoFields } } \(fragment)
      """
      let variables: [String : Any] = ["input": ["query": place]]

      return ["query": query, "variables": variables]
}
