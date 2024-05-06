//
//  PrismDMX_ProApp.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import SwiftUI
import Foundation

@main
struct PrismDMX_ProApp: App {
    @State var packet: Packet = Packet(project: nil, availableProjects: [Project(internalID: "0", name: "error"), Project(internalID: "1", name: "error1")], fixtures: [], fixtureTemplates: [], mixer: Mixer(pages: [], color: "0xffffff", isMixerAvailable: "false", mixerType: "0"), fixtureGroups: [])
    @State var connected: Bool = false
    @State var error: String?
    #if os(iOS)
    @State var iOSWorkspace: Workspace = Workspace(isCompleted: false, settings: Settings(ip: "ws://192.168.178.187", port: "8000/ws/main"), displayMode: 0, notes: [], columnVisible: .all)
    #endif
    var body: some Scene {
        /*WindowGroup {
            VStack {
                ForEach(packet.availableProjects.indices, id: \.self) { index in
                    Text(packet.availableProjects[index].name)
                }
            }
        }*/
        #if os(macOS)
        DocumentGroup(newDocument: PrismDMXProDocument()) { file in
            mainView(document: file.$document,connected: $connected, error: $error, packet: $packet, websocket: Websocket(connected: $connected, error: $error, workspace: file.$document.workspace, packet: $packet))
        }
        .commands {
            CommandGroup(after: .newItem) {
                Button("Projects") { packet.project = nil }
                    .disabled(!$connected.wrappedValue)
            }
        }
        #else
        WindowGroup {
            iOSView(workspace: $iOSWorkspace, packet: $packet, connected: $connected, error: $error, websocket: Websocket(connected: $connected, error: $error, workspace: $iOSWorkspace, packet: $packet))
        }
        #endif
    }
}
