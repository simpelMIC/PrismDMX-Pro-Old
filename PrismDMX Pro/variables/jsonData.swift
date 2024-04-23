//
//  jsonData.swift
//  PrismDMX Pro
//
//  Created by Christian on 23.04.24.
//

import Foundation

struct Fixture: Equatable, Identifiable, Codable {
    var id = UUID()
    var internalID: String
    var name: String
    var FixtureGroup: String
    var template: String
    var startChannel: String
}
