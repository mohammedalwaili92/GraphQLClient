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
            let body = GraphQLURLQueryBuilder().add(query: GetStoresQuery(place: "Borne")).build()
            
            let request = try client.makeRequest(params: body)
//            let request = try client.makeRequest(body: GetStoresQuery(place: "borne"))
            let stores: Stores = try await client.fetch(request: request)
            self.stores = stores.data.storeSearchV2
            print(stores)
        } catch {
            print(error)
        }
        
//        do {
//            let request = try client.makeRequest(body: UpdateUserDataMutation(firstName: "Mo2"))
//            let result: UpdateUserDataResponse = try await client.fetch(request: request)
//            print(result)
//        } catch {
//            print(error)
//        }
    }
}
