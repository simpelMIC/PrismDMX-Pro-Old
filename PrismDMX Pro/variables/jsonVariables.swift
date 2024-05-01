//
//  jsonVariables.swift
//  PrismDMX Pro
//
//  Created by Christian on 29.04.24.
//

import Foundation

struct Fixture: Equatable, Codable {
    var internalID: String
    var name: String
    var FixtureGroup: String
    var template: String
    var startChannel: String
    var channels: [Channel]
}

struct FixtureTemplate: Equatable, Codable, Hashable {
    var internalID: String
    var name: String
    var channels: [Channel]
}

struct Channel: Equatable, Codable, Hashable {
    var internalID: String
    var ChannelName: String
    var ChannelType: String
    var dmxChannel: String
}

struct Packet: Equatable, Codable {
    var project: Project?
    var availableProjects: [Project]
    var fixtures: [Fixture]
    var fixtureTemplates: [FixtureTemplate]
    var mixer: Mixer
    var fixtureGroups: [FixtureGroup]
}

struct Project: Equatable, Codable {
    var internalID: String
    var name: String
}

struct FixtureGroup: Equatable, Codable {
    var name: String
    var internalIDs: [String]
}

struct newFixture: Equatable, Codable {
    var newFixture: hiJuDasIstEineNeueFixture
}

struct editFixture: Equatable, Codable {
    var editFixture: hiJuDasIstEineNeueFixture
}

struct hiJuDasIstEineNeueFixture: Equatable, Codable {
    var fixture: Fixture
}

struct DeleteFixture: Equatable, Codable {
    var deleteFixture: hiJuDasIstDieFixture
}

struct hiJuDasIstDieFixture: Equatable, Codable {
    var internalID: String
}

struct hiJuDasIstEinNeuesProject: Equatable, Codable {
    var project: Project
}

struct newProject: Equatable, Codable {
    var newProject: hiJuDasIstEinNeuesProject
}

struct setProject: Equatable, Codable {
    var setProject: hiJuDasIstEinNeuesProject
}

struct deleteProject: Equatable, Codable {
    var deleteProject: hiJuDasIstEinNeuesProject
}
