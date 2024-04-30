//
//  tree.swift
//  PrismDMX Pro
//
//  Created by Christian on 29.04.24.
//

import Foundation
import SwiftUI

struct mainView: View {
    @Binding var document: PrismDMXProDocument
    @Binding var connected: Bool
    @Binding var error: String?
    @State var isConnectedToMixer: Bool = false
    @Binding var packet: Packet
    @State var websocket: Websocket
    
    var body: some View {
        #if os(macOS)
        loadingMainView(websocket: Websocket(connected: $connected, error: $error, workspace: $document.workspace, packet: $packet), connected: $connected, error: $error, packet: $packet, workspace: $document.workspace)
            .onAppear {
                connected = false
                error = nil
            }
            .onDisappear {
                print("Window closed")
            }
            .toolbar(content: {
                Text("WS PROJECT: \(document.workspace.settings.project?.name ?? "NO PROJECT")")
            })
        #endif
        //iOSView(workspace: $document.workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
    }
    
    func disconnect() {
        document.workspace.isCompleted = false
        connected = false
        error = nil
    }
}
