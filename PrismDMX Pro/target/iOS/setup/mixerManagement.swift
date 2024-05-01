//
//  mixerManagement.swift
//  PrismDMX Pro
//
//  Created by Christian on 01.05.24.
//

import Foundation
import SwiftUI

struct iOSMixerConfigView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        VStack {
            List {
                NavigationLink(destination: MixerDisplayConfigView(workspace: $workspace, websocket: $websocket, packet: $packet), label: { Text("Displays") })
                NavigationLink(destination: MixerLightingConfigView(workspace: $workspace, websocket: $websocket, packet: $packet), label: { Text("Lighting") })
                NavigationLink(destination: MixerFaderConfigView(workspace: $workspace, websocket: $websocket, packet: $packet), label: { Text("Faders") })
            }
            .navigationTitle("Mixer Configuration")
        }
    }
}

struct MixerDisplayConfigView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    @State private var displayModes: [String] = ["Master", "Fixtures", "Mixer", "Playbacks"]
    @State private var selectedIndex: Int = 0
    
    private var selectedTemplate: String {
        return displayModes[selectedIndex]
    }
    var body: some View {
        VStack {
            List {
                Section("Monitors") {
                    Picker("This iPad displays", selection: $selectedIndex) {
                        ForEach(displayModes.indices, id: \.self) { index in
                            Text(displayModes[index])
                        }
                    }
                    .onChange(of: selectedIndex, {
                        workspace.displayMode = selectedIndex
                        iOSDataModule().save($workspace)
                    })
                }
            }
            .navigationTitle("Displays")
            .onAppear {
                selectedIndex = workspace.displayMode
            }
        }
    }
}

struct MixerLightingConfigView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        Text("Lighting")
    }
}

struct MixerFaderConfigView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        Text("Faders")
    }
}
