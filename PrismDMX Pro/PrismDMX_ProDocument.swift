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

    init(workspace: Workspace = Workspace(isCompleted: false, settings: Settings(ip: "ws://127.0.0.1", port: "8000/ws/main", project: nil))) {
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
