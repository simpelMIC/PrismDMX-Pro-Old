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
    @State var connected: Bool = false
    @State var error: String? = nil
    @State var isConnectedToMixer: Bool = false
    
    var body: some View {
        nearlyMainView(document: $document, websocket: Websocket(connected: $connected, error: $error), connected: $connected, error: $error)
            .onAppear {
                connected = false
                error = nil
            }
            .onDisappear {
                print("Window closed")
            }
    }
}

struct nearlyMainView: View {
    @Binding var document: PrismDMXProDocument
    @State var websocket: Websocket
    
    @Binding var connected: Bool
    @Binding var error: String?
    var body: some View {
        VStack {
            if document.workspace.isCompleted == true {
                if connected == true && error == nil { //If the client connects successfully
                    WorkspaceView(workspace: $document.workspace)
                    
                } else if connected == true && error != nil { //If the client connects but there is an error
                    Text("An error occured: \(error ?? "")")
                    Button {
                        websocket.disconnect(response: true)
                        websocket.connect(ip: $document.workspace.settings.wsSettings.ip, port: $document.workspace.settings.wsSettings.port, response: true)
                    } label: {
                        Text("Retry")
                    }
                    Button {
                        websocket.disconnect(response: true)
                        document.workspace.isCompleted = false
                    } label: {
                        Text("Settings")
                    }
                    
                } else if connected == false && error != nil { //If the client had an error connecting
                    Text("An error occured: \(error ?? "")")
                    Button {
                        websocket.disconnect(response: true)
                        websocket.connect(ip: $document.workspace.settings.wsSettings.ip, port: $document.workspace.settings.wsSettings.port, response: true)
                    } label: {
                        Text("Retry")
                    }
                    Button {
                        websocket.disconnect(response: true)
                        document.workspace.isCompleted = false
                    } label: {
                        Text("Settings")
                    }

                } else if connected == false && error == nil { //If the client is still connecting
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
                ConfigView(wsSettings: $document.workspace.settings.wsSettings, workspace: $document.workspace, connected: $connected, error: $error )
                
            }
        }
        .onDisappear {
            websocket.disconnect(response: true)
        }
    }
}

struct ConfigView: View {
    @Binding var wsSettings: WsSettings
    @Binding var workspace: Workspace
    @Binding var connected: Bool
    @Binding var error: String?
    var body: some View {
        VStack {
            Text("Websocket Settings")
                .font(.title)
            TextField("IP", text: $wsSettings.ip)
            TextField("Port", text: $wsSettings.port)
            Text("Final Destination Address: \(wsSettings.ip):\(wsSettings.port)")
            Spacer()
            Button {
                workspace.isCompleted.toggle()
                connected = false
                error = nil
            } label: {
                Text("Continue")
            }

        }
        .padding()
    }
}

#Preview {
    nearlyMainView(document: .constant(PrismDMXProDocument(workspace: Workspace(isCompleted: true, settings: Settings(wsSettings: WsSettings(ip: "127.0.0.1", port: "8888")), fixtures: []))), websocket: Websocket(connected: .constant(true), error: .constant(nil)), connected: .constant(true), error: .constant(nil))
}
