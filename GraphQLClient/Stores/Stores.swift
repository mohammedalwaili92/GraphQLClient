//
//  Stores.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import Foundation

struct Address: Decodable {
    let street: String
}

struct StoreSearchV2: Decodable {
    let name: String
    let address: Address
}

struct StoresData: Decodable {
    let storeSearchV2: [StoreSearchV2]
}

struct Stores: Decodable {
    let data: StoresData
}
