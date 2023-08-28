//
//  GraphQLClientApp.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import SwiftUI

@main
struct GraphQLClientApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: .init(client: ActionGraphQLClient()))
        }
    }
}
