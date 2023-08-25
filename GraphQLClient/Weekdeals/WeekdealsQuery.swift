//
//  WeekdealsQuery.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

struct WeekdealsQuery: GraphQLQuery {
    
    let operationName: String = "GetWeekdeals"
    
    var query: String {
        """
        query GetWeekdeals($weekOffset: Int) {
          weekdeals(weekOffset: $weekOffset) {
            promotionProducts {
              product {
                brand
              }
            }
          }
        }
        """
    }
    
    let variables: [String : Any]? = [
        "weekOffset": 0
    ]
}
