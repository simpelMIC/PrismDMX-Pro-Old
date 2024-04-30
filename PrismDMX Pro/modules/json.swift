//
//  json.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation
import SwiftUI

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
