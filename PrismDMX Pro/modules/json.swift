//
//  json.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation
import SwiftUI

/*
class fixtureTemplateJson {
    func encode(_ fixtureTemplate: fixtureTemplate) -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(fixtureTemplate)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        return json!
    }
        
    func decode(_ input: String) -> fixtureTemplate {
        let jsonDecoder = JSONDecoder()
        let json = try! jsonDecoder.decode(fixtureTemplate.self, from: input.data(using: .utf8)!)
        return json
    }
}

class fixturesJson {
    func encode(_ fixtures: fixtures) -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(fixtures)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        return json!
    }
    
    func decode(_ input: String) -> fixtures {
        let jsonDecoder = JSONDecoder()
        let json = try! jsonDecoder.decode(fixtures.self, from: input.data(using: .utf8)!)
        return json
    }
}
 */

struct Fixture: Equatable, Codable {
    var internalID: String
    var name: String
    var FixtureGroup: String
    var template: String
    var startChannel: String
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

struct packet: Equatable, Codable {
    var fixtures: [Fixture]
    var fixtureTemplates: [fixtureTemplate]
}

struct newFixture: Equatable, Codable {
    var newFixture: hiJuDasIstEineNeueFixture
}

struct hiJuDasIstEineNeueFixture: Equatable, Codable {
    var fixture: Fixture
}

class JsonModule {
    func encode(_ newFixture: newFixture) -> String? {
        let encoder = JSONEncoder()
        if let json = try? encoder.encode(newFixture) {
            return String(data: json, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    func decode(_ data: Data) -> packet? {
        let decoder = JSONDecoder()
        if let packetData = try? decoder.decode(packet.self, from: data) {
            return packetData
        } else {
            return nil
        }
    }
}

struct JSONView: View {
    @Binding var fixtures: [Fixture]
    @Binding var workspace: Workspace
    @State private var jsonData: String?
    
    var body: some View {
        VStack {
            
        }
        .padding()
    }
}
