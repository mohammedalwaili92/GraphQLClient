//
//  StoreInfoFieldsFragment.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

struct StoreInfoFieldsFragment: GraphQLFragment {
    var value: String {
            """
            fragment storeInfoFields on StoreV2 {
              __typename
              id
              name
              address {
                __typename
                street
                houseNumber
                houseNumberExtra
                postalCode
                city
              }
              openingDays {
                __typename
                dayName
                description
                closed
                openingHour {
                  __typename
                  openFrom
                  openUntil
                }
              }
            }
            """
    }
}
