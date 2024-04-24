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

struct Settings: Equatable, Identifiable, Codable {
    var id = UUID()
    var wsSettings: WsSettings
}

struct WsSettings: Equatable, Identifiable, Codable {
    var id = UUID()
    var ip: String
    var port: String
}
