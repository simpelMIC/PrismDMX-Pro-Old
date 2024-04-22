//
//  macOSView.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation
import SwiftUI

enum SideBarItem: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    
    case setup
    case config
    case playbacks
}

struct mainView: View {
    @Binding var document: PrismDMXProDocument
    @State var websocket: Websocket
    
    @Binding var connected: Bool
    @Binding var error: String?
    var body: some View {
        Pre_View(document: $document, websocket: $websocket, connected: $connected, error: $error)
    }
}

struct Pre_View: View {
    @Binding var document: PrismDMXProDocument
    @Binding var websocket: Websocket
    
    @Binding var connected: Bool
    @Binding var error: String?
    
    var body: some View {
        VStack {
            if document.workspace.isCompleted == true {
                if connected == true && error == nil {
                    WorkspaceView(workspace: $document.workspace)
                } else if connected == true && error != nil {
                    Text("An error occured")
                } else if connected == false && error != nil {
                    Text("An error occured")
                } else if connected == false && error == nil {
                    Text("Connecting...")
                    .onAppear {
                        websocket.connect(ip: $document.workspace.settings.wsSettings.ip, port: $document.workspace.settings.wsSettings.port, response: true)
                    }
                    Button {
                        websocket.disconnect(response: true)
                        connected = false
                        error = nil
                        document.workspace.isCompleted = false
                    } label: {
                        Text("Cancel")
                    }
                }
            } else {
                ConfigView(wsSettings: $document.workspace.settings.wsSettings, workspace: $document.workspace)
            }
        }
    }
}

struct ConfigView: View {
    @Binding var wsSettings: WsSettings
    @Binding var workspace: Workspace
    var body: some View {
        VStack {
            Text("Setup your new project")
                .font(.title)
            TextField("IP", text: $wsSettings.ip)
            TextField("Port", text: $wsSettings.port)
            Text("Final Destination Address: \(wsSettings.ip):\(wsSettings.port)")
            Spacer()
            Button {
                workspace.isCompleted.toggle()
            } label: {
                Text("Continue")
            }

        }
        .padding()
    }
}

#Preview {
    mainView(document: .constant(PrismDMXProDocument(workspace: Workspace(isCompleted: false, settings: Settings(wsSettings: WsSettings(ip: "", port: ""))))), websocket: Websocket(connected: .constant(true), error: .constant(nil)), connected: .constant(true), error: .constant(nil))
}
