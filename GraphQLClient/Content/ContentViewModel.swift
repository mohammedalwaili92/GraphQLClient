//
//  ContentViewModel.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import Foundation
import SwiftUI

@MainActor
final class ContentViewModel: ObservableObject {
    
    private let client: GraphQLClient
    
    @Published var stores: [StoreSearchV2] = []
    @Published var products: [WeekdealsPromotionProductInnerProduct] = []
    
    init(client: GraphQLClient) {
        self.client = client
    }
    
    func onAppear() async {
        do {
//            let stores: Stores = try await client.fetch(query: GetStoresQuery(place: "Oisterwijk"))
//            self.stores = stores.data.storeSearchV2
            
            let weekdealsResponse: WeekdealsResponse = try await client.fetch(query: WeekdealsQuery())
            self.products = weekdealsResponse.data.weekdeals.promotionProducts.map { $0.product }
        } catch {
            print(error)
        }
    }
}
