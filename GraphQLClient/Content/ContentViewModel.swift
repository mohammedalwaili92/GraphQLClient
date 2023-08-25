//
//  ContentViewModel.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import Foundation
import SwiftUI

// Update this token to use for the mutations
let token = """
eyJhbGciOiJBMjU2S1ciLCJlbmMiOiJBMjU2Q0JDLUhTNTEyIiwidHlwIjoiSldUIn0.e2N_I8ALLnWNaV44caxD1BgtBpIyy6RMuuoVUA9JfTzo69Q449GcaBG-e-dqzO9hJqZUNhvZAdVGHKvuPT0HHMohyGynbXA3.MGq14tdmWVvmTKurB4_olQ.WiEvbNsM-gZIKmQZeuFkRg3Ohn_4DZWJCTY5Atoeimc4P_Xo6rtKVSTmS3aHFhU6QDXZtizWJNlSLZiB0iVZJzcdgGM86YkhfUSvGv5hL6lMUvq6nCdmomoFeMeaob_4_TsoI4Zy-MJuyQipRuCpthwHtK_KNlnG6W_zZO6yWO8-i_Q_BIgr2QHI0CAG74hxLTTCyYSsxhphVwcPwA3v67D-_FPMpBWSou8Y2eTYNGv-0TtosKW53TBG8K-YbA5fEsxJHRm-RxZ8AFUElL6F0RaglKYSsJcWJGIXCenNs6dStU2NtVj3ISaXGE5eyvyjkHnHx_FI13xq-SvBmZeqGiHzrhk4FhUUQz0AgP1Xlxy-uP7NSmUBmzpBK67LyAmzAkhbEm7xvxEt66QTDGbTv2Gme5nMpAUyOL5pJpdchXwl4_s02R_ibUO89xVraAveCN6fsxwYwZxdT9fN7I2U4i58ptbcIuuqFkv_Qdm7jG76OX6Ifb1_HkfkrwrLpiGNkG3U7gZNNAYcP9fbA8FgQ8y1aCO_EJoHEdOO5ZEX48fNcKM6LdEqwzYde-G6cwiY1WTqsAjKOHnoWjcsNMIzYESWUtE4s5XBd0apUhKtfxrN9dglipZSKOQ4i0jakVCPtY9sQI6x5ikOCvBqB91HDQBhC2br_aGYyDLRnuFTDIKXnIqvDN2H8PKESp3D3MsfAUoK3lLnrEIYlO0Z6XRu1glpIROPilXCSq_tzoQv5cu5uOBn2dYa8dbymybu3b-4Uy5m6OFAhnhnvsk7Mvd67w.5Qk3m_PE7IZMhzvlEwfnmGuz2d4GflteX-4tXnHkbgM
"""

@MainActor
final class ContentViewModel: ObservableObject {
    
    private let client: GraphQLClient
    
    @Published var stores: [StoreSearchV2] = []
    @Published var products: [WeekdealsPromotionProductInnerProduct] = []
    
    init(client: GraphQLClient) {
        self.client = client
    }
    
    func loadData() async {
        do {
            let stores: Stores = try await client.fetch(query: GetStoresQuery(place: "Oisterwijk"))
            self.stores = stores.data.storeSearchV2
            
//            let weekdealsResponse: WeekdealsResponse = try await client.fetch(query: WeekdealsQuery())
//            self.products = weekdealsResponse.data.weekdeals.promotionProducts.map { $0.product }
            
//            let response: UpdateUserDataResponse = try await client.perform(mutation: UpdateUserDataMutation(firstName: "Mooooo"))
//            print(response.success)
        } catch {
            print(error)
        }
    }
}
