//
//  Variables.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation

struct Workspace: Equatable, Identifiable, Codable {
    var id = UUID()
    var text: String
}

struct fixture: Equatable, Identifiable, Codable {
    var id = UUID()
    var internalID: Int
    var FixtureGroup: Int
    var template: Int
    var startChannel: Int
}

struct fixtures: Equatable, Identifiable, Codable {
    var id = UUID()
    var fixtures: [fixture]
}

struct fixtureTemplate: Equatable, Identifiable, Codable {
    var id = UUID()
    var internalID: Int
    var name: String
    var channels: [Channel]
}

struct Channel: Equatable, Identifiable, Codable {
    var id = UUID()
    var internalID: Int
    var channelType: String
    var dmxChannel: Int
}
