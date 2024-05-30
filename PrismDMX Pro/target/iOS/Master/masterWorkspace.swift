//
//  workspace.swift
//  PrismDMX Pro
//
//  Created by Christian on 29.04.24.
//

import Foundation
import SwiftUI

struct iOSMasterView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        if packet.setup == "false" {
            NavigationSplitView(columnVisibility: $workspace.columnVisible) {
                List {
                    //Setup
                    if packet.mixer.isMixerAvailable == "False" {
                        NavigationLink {
                            NavigationStack {
                                iOSSetup(workspace: $workspace, websocket: $websocket, packet: $packet)
                            }
                        } label: {
                            Text("Setup")
                        }
                    }
                    
                    //Fixtures
                    NavigationLink {
                        FixtureView(workspace: $workspace, websocket: $websocket, packet: $packet)
                    } label: {
                        Text("Fixtures")
                    }
                    
                    //Mixer
                    NavigationLink {
                        iOSConfigView(workspace: $workspace, websocket: $websocket, packet: $packet)
                    } label: {
                        if $packet.mixer.isMixerAvailable.wrappedValue == "True" {
                            Text("Mixer")
                        } else {
                            Text("Config")
                        }
                    }
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
        } else {
            NavigationStack {
                iOSSetup(workspace: $workspace, websocket: $websocket, packet: $packet)
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
                            workspace.project = nil
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
