//
//  jsonVariables.swift
//  PrismDMX Pro
//
//  Created by Christian on 29.04.24.
//

import Foundation

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
    var setup: String
    var channels: String //Bool
    var selectedFixtureIDs: [String] //Int Array
    var selectedFixtureGroupIDs: [String] //Int Array
}

struct Project: Equatable, Codable {
    var internalID: String
    var name: String
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

struct editMixerFader: Equatable, Codable {
    var editMixerFader: hiJuDasIstEineMixerFaderVeränderung
}

struct hiJuDasIstEineMixerFaderVeränderung: Equatable, Codable {
    var fader: MixerFader
}

struct hiJuDasIstEineMixerButtonVeränderung: Equatable, Codable {
    var fader: MixerFader
}

struct editMixerButton: Equatable, Codable {
    var editMixerButton: hiJuDasIstEineMixerButtonVeränderung
}
