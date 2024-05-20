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
                    localColor = rgbToHexString(color: bgColor)
                })
                .onSubmit() {
                    save()
                }
        }
        .navigationTitle("Lighting")
        .onAppear {
            bgColor = hexStringToRGB(hex: packet.mixer.color)
        }
        .onDisappear {
            save()
        }
        .toolbar(content: {
            Button("Save") {
                save()
            }
        })
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
    
    func hexStringToRGB(hex: String) -> Color {
        // Remove the '#' if it exists
        let cleanedHex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        // Ensure the string is 6 characters long
        guard cleanedHex.count == 6 else {
            return Color.white // default to white color if invalid
        }
        
        // Extract RGB values
        let redHex = String(cleanedHex.prefix(2))
        let greenHex = String(cleanedHex.dropFirst(2).prefix(2))
        let blueHex = String(cleanedHex.dropFirst(4).prefix(2))
        
        // Convert hex strings to Int values
        let redInt = Int(redHex, radix: 16) ?? 255
        let greenInt = Int(greenHex, radix: 16) ?? 255
        let blueInt = Int(blueHex, radix: 16) ?? 255
        
        // Create Color from RGB values
        return Color(
            red: Double(redInt) / 255.0,
            green: Double(greenInt) / 255.0,
            blue: Double(blueInt) / 255.0
        )
    }
    
    func save() {
        websocket.sendNonBindingString("{ \"setMixerColor\": \"\(localColor)\" }", response: true)
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
