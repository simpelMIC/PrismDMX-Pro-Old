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
    var project: Project?
    var displayMode: Int
    var notes: [Note]
}

struct Settings: Equatable, Identifiable, Codable {
    var id = UUID()
    var ip: String
    var port: String
}

struct Note: Equatable, Identifiable, Codable {
    var id = UUID()
    var name: String
    var content: String
}
