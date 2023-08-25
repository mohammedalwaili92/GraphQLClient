//
//  Weekdeals.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

struct WeekdealsResponse: Decodable {
    let data: WeekdealsData
}

struct WeekdealsData: Decodable {
    let weekdeals: Weekdeals
}

struct Weekdeals: Decodable {
    let promotionProducts: [WeekdealsPromotionProduct]
}

struct WeekdealsPromotionProductInnerProduct: Decodable {
    let brand: String?
}

struct WeekdealsPromotionProduct: Decodable {
    let product: WeekdealsPromotionProductInnerProduct
}
