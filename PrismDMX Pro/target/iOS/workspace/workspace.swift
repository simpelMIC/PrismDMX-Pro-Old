//
//  workspace.swift
//  PrismDMX Pro
//
//  Created by Christian on 29.04.24.
//

import Foundation
import SwiftUI

struct iOSWorkspaceView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink(destination: iOSSettings(workspace: $workspace, websocket: $websocket, packet: $packet), label: { Text("Settings") })
                NavigationLink(destination: iOSSetupView(workspace: $workspace, websocket: $websocket, packet: $packet), label: { Text("Setup") })
                NavigationLink(destination: iOSConfigView(), label: { Text("Config") })
            }
            .navigationTitle(packet.project?.name ?? "Workspace")
        } detail: {
            ZStack {
                Image("light-lights-led-812677")
                Rectangle()
                    .fill(.clear)
                    .background(Material.regular)
                VStack {
                    HStack {
                        Text("Welcome to PrismDMX Pro")
                            .font(.title)
                            .fontWeight(.black)
                        Image("icon_512x512")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipped()
                    }
                    Text("Select a category")
                }
            }
        }
    }
}

struct iOSSettings: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        VStack {
            List {
                NavigationLink {
                    Text("Loading")
                        .onAppear {
                            workspace.isCompleted = false
                            websocket.disconnect(response: true)
                        }
                } label: {
                    Text("Network Settings")
                }
                NavigationLink {
                    Text("Loading...")
                        .onAppear {
                            workspace.settings.project = nil
                            packet.project = nil
                        }
                } label: {
                    Text("Change Project")
                }
            }
            .navigationTitle("App Settings")
        }
    }
}

struct iOSSetupView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        iOSSetup(workspace: $workspace, websocket: $websocket, packet: $packet)
    }
}

struct iOSConfigView: View {
    var body: some View {
        Text("Config")
    }
}
