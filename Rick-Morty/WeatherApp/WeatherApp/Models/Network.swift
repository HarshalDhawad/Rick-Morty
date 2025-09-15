//
//  Network.swift
//  WeatherApp
//
//  Created by Harshal Dhawad on 01/09/25.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()
  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)
}
