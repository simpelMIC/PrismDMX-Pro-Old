//
//  Variables.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation

struct Workspace: Equatable, Identifiable, Codable {
    var id = UUID()
    var isCompleted: Bool
    var settings: Settings
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
    var color: color
}

struct color: Equatable, Identifiable, Codable {
    var id = UUID()
    var R: UInt8
    var G: UInt8
    var B: UInt8
}

struct Settings: Equatable, Identifiable, Codable {
    var id = UUID()
    var wsSettings: WsSettings
}

struct WsSettings: Equatable, Identifiable, Codable {
    var id = UUID()
    var ip: String
    var port: String
}
