//
//  json.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation
import SwiftUI

struct Fixture: Equatable, Codable {
    var internalID: String
    var name: String
    var FixtureGroup: String
    var template: String
    var startChannel: String
    var channels: [Channel]
}

struct fixtureTemplate: Equatable, Codable, Hashable {
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
    var fixtureTemplates: [fixtureTemplate]
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

class JsonModule {
    func encodeNewFixture(_ newFixture: newFixture) -> String? {
        let encoder = JSONEncoder()
        if let json = try? encoder.encode(newFixture) {
            return String(data: json, encoding: .utf8)
        } else {
            print("Error encoding newFixture")
            return nil
        }
    }
    
    func encodeEditFixture(_ editFixture: editFixture) -> String? {
        let encoder = JSONEncoder()
        if let json = try? encoder.encode(editFixture) {
            return String(data: json, encoding: .utf8)
        } else {
            print("Error encoding editFixture")
            return nil
        }
    }
    
    func encodeFixtureDeletion(_ deleteFixture: DeleteFixture) -> String? {
        let encoder = JSONEncoder()
        if let json = try? encoder.encode(deleteFixture) {
            return String(data: json, encoding: .utf8)
        } else {
            print("Error encoding fixtureDeletion")
            return nil
        }
    }
    
    func encodePacket(_ packet: Packet) -> String? {
        let encoder = JSONEncoder()
        if let json = try? encoder.encode(packet) {
            return String(data: json, encoding: .utf8)
        } else {
            print("Error encoding packet")
            return nil
        }
    }
    
    func encodeNewProject(_ newProject: newProject) -> String? {
        let encoder = JSONEncoder()
        if let json = try? encoder.encode(newProject) {
            return String(data: json, encoding: .utf8)
        } else {
            print("Error encoding packet")
            return nil
        }
    }
    
    func encodeSetProject(_ setProject: setProject) -> String? {
        let encoder = JSONEncoder()
        if let json = try? encoder.encode(setProject) {
            return String(data: json, encoding: .utf8)
        } else {
            print("Error encoding packet")
            return nil
        }
    }
    
    func decode(_ data: Data) -> Packet? {
        let decoder = JSONDecoder()
        if let packetData = try? decoder.decode(Packet.self, from: data) {
            return packetData
        } else {
            print("Error decoding packet")
            return nil
        }
    }
}
