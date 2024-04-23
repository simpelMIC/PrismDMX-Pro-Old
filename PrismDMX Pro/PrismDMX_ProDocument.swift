//
//  PrismDMX_ProDocument.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var prismDMXProDocument: UTType {
        UTType(exportedAs: "de.micstudios.pmxpro")
    }
}

struct PrismDMXProDocument: FileDocument, Codable {
    var workspace: Workspace

    init(workspace: Workspace = Workspace(isCompleted: false, settings: Settings(wsSettings: WsSettings(ip: "ws://127.0.0.1", port: "80")), fixtures: [], fixtureTemplates: [fixtureTemplate(internalID: "0", name: "Lixada Wash Moving Head", channels: []), fixtureTemplate(internalID: "1", name: "Lixada 12 LED", channels: [])])) {
        self.workspace = workspace
    }
    
    static var readableContentTypes: [UTType] { [.prismDMXProDocument] }

    init(configuration: ReadConfiguration) throws {
        let data = configuration.file.regularFileContents!
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self)
        return .init(regularFileWithContents: data)
    }
}
