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
        VStack {
            ForEach(viewModel.stores) { store in
                Text(store.name)
                Text(store.address.street)
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
