//
//  iOSView.swift
//  PrismDMX Pro
//
//  Created by Christian on 29.04.24.
//

import Foundation
import SwiftUI

struct iOSView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    var body: some View {
        NavigationStack {
            ZStack {
                AsyncImage(url: URL(string: "https://prismdmx.micstudios.de/light-lights-led-812677.jpg"))
                Rectangle()
                    .fill(.clear)
                    .background(Material.regular)
                VStack {
                    HStack {
                        Text("Welcome to PrismDMX")
                            .font(.title)
                            .fontWeight(.black)
                        AsyncImage(url: URL(string:"https://prismdmx.micstudios.de/icon_512x512.png"), scale: 10)
                    }
                    ConnectionView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
                }
            }
        }
    }
}

struct ConnectionView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    
    @State var isSheetPresented: Bool = false
    var body: some View {
        VStack {
            if connected == true && error == nil {
                //Workspace
            } else {
                Text("Not connected")
                Button("Connect") {
                    isSheetPresented.toggle()
                }
                .onAppear {
                    isSheetPresented.toggle()
                }
            }
        }
        .sheet(isPresented: $isSheetPresented, content: {
            ConnectionViewSheet(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
                .padding(20)
        })
    }
}

struct ConnectionViewSheet: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    var body: some View {
        if workspace.isCompleted == true {
            if connected == true && error == nil {
                Text("Loading...")
            } else if connected == true && error != nil {
                iOSErrorView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
            } else if connected == false && error != nil {
                iOSErrorView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
            } else if connected == false && error == nil {
                iOSisConnectingView(workspace: $workspace, websocket: $websocket)
            }
        } else {
            iOSNWSettingsView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
        }
    }
}

struct iOSisConnectingView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    var body: some View {
        Text("Connecting...")
        Button("Cancel") {
            workspace.isCompleted = false
        }
        .onAppear {
            websocket.connect(ip: $workspace.settings.ip, port: $workspace.settings.port, response: true)
        }
    }
}

struct iOSErrorView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    var body: some View {
        VStack {
            Text("An error occured: \(error ?? "unknown error")")
            Button("Retry") {
                websocket.disconnect(response: true)
                websocket.connect(ip: $workspace.settings.ip, port: $workspace.settings.port, response: true)
            }
            Button("Settings") {
                workspace.isCompleted = false
            }
        }
    }
}

struct iOSNWSettingsView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    var body: some View {
        VStack {
            Text("Network Settings")
                .font(.title)
                .fontWeight(.black)
            HStack {
                Text("IP: ")
                TextField("IP", text: $workspace.settings.ip)
            }
            HStack {
                Text("Port: ")
                TextField("Port", text: $workspace.settings.port)
            }
            Spacer()
            Button("Connect") {
                workspace.isCompleted = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
