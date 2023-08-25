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
    
    init(client: GraphQLClient) {
        self.client = client
    }
    
    func onAppear() async {
        do {
            let stores: Stores = try await client.fetch(query: GetStoresQuery(place: "Tilburg"))
            self.stores = stores.data.storeSearchV2
        } catch {
            print(error)
        }
    }
}
