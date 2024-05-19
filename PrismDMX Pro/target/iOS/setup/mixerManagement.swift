//
//  mixerManagement.swift
//  PrismDMX Pro
//
//  Created by Christian on 01.05.24.
//

import Foundation
import SwiftUI

///#TODO:
///- Fader IDs
///- Fader Presets
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
    
    @State private var displayModes: [String] = ["Master", "Fixtures", "Mixer", "Playbacks", "StageNotes"]
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
    
    @State private var bgColor = Color(.sRGB, red: 1.0, green: 1.0, blue: 1.0)
    @State private var localColor: String = "#ffffff"
    var body: some View {
        List {
            ColorPicker("Color", selection: $bgColor)
                .onChange(of: bgColor, {
                    websocket.sendNonBindingString("{ \"setMixerColor\": \"\(rgbToHexString(color: bgColor))\" }", response: true)
                })
        }
        .navigationTitle("Lighting")
    }
    
    func rgbToHexString(color: Color) -> String {
        guard let components = color.cgColor?.components else {
            return "#ffffff"
        }
        
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        
        let redHex = String(format: "%02X", Int(red * 255))
        let greenHex = String(format: "%02X", Int(green * 255))
        let blueHex = String(format: "%02X", Int(blue * 255))
        
        return "#" + redHex + greenHex + blueHex
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
