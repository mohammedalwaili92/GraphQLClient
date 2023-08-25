//
//  ContentView.swift
//  GraphQLClient
//
//  Created by Mohammed Al Waili on 23/08/2023.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(viewModel.stores.enumerated()), id: \.offset) { _, store in
                    HStack {
                        Text(store.name)
                        Text(store.address.street)
                    }
                    
                }
                
                ForEach(Array(viewModel.products.enumerated()), id: \.offset) { _, product in
                    Text(product.brand ?? "")
                }
            }
        }
        .padding()
        .onAppear {
            Task { @MainActor in
                await viewModel.onAppear()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ContentViewModel(client: GraphQLClientImp()))
    }
}
