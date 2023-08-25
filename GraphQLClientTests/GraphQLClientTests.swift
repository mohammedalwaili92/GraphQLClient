//
//  GraphQLClientTests.swift
//  GraphQLClientTests
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import XCTest
@testable import GraphQLClient

@MainActor
final class GraphQLClientTests: XCTestCase {

    func test_loadData_updatesStores() async {
        let components = makeSUT()
        let data = StoresData(storeSearchV2: [
            StoreSearchV2(name: "A city", address: Address(street: "a street"))
        ])
        components.client.fetchResponse = Stores(data: data)
        
        await components.sut.loadData()
    
        XCTAssertFalse(components.sut.stores.isEmpty)
    }
    
    private func makeSUT() -> (sut: ContentViewModel,
                               client: ClientMock) {
        let client = ClientMock()
        let sut = ContentViewModel(client: client)
        
        return (sut, client)
    }
    
}

final class ClientMock: GraphQLClient {
    
    init() { }
    
    var fetchError: Error?
    var fetchResponse: (any Decodable)!
    func fetch<T>(query: GraphQLQuery) async throws -> T where T : Decodable {
        if let fetchError {
            throw fetchError
        }
        return fetchResponse as! T
    }
    
    var performError: Error?
    var performResponse: (any Decodable)!
    func perform<T>(mutation: GraphQLMutation) async throws -> T where T : Decodable {
        if let performError {
            throw performError
        }
        return performResponse as! T
    }
    
}
