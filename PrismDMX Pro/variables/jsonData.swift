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

struct fixtureTemplate: Equatable, Identifiable, Codable, Hashable {
    var id = UUID()
    var internalID: String
    var name: String
    var channels: [Channel]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(internalID)
        hasher.combine(name)
        // You may need to implement a custom hashValue for Channel
        for channel in channels {
            hasher.combine(channel)
        }
    }
}

struct Channel: Equatable, Identifiable, Codable, Hashable {
    var id = UUID()
    var internalID: String
    var ChannelName: String
    var ChannelType: String
    var dmxChannel: String

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(internalID)
        hasher.combine(ChannelName)
        hasher.combine(ChannelType)
        hasher.combine(dmxChannel)
    }
}
