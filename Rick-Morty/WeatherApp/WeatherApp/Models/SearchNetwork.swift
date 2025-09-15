//
//  SearchNetwork.swift
//  WeatherApp
//
//  Created by Harshal Dhawad on 15/09/25.
//

import Foundation
import UIKit
import Apollo

class SearchNetwork {
    static var shared = SearchNetwork()
    private(set) lazy var searchApollo = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)
}
