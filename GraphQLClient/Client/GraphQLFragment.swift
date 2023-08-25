//
//  GraphQLFragment.swift
//  GraphQLClient
//
//  Created by Mohammed Alwaili on 25/08/2023.
//

import Foundation

protocol GraphQLFragment: CustomStringConvertible {
    var value: String { get }
}

extension GraphQLFragment {
    
    var description: String {
        value
    }
}
