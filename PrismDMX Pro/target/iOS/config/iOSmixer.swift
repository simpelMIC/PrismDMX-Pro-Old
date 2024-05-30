//
//  config.swift
//  PrismDMX Pro
//
//  Created by Christian on 01.05.24.
//

import Foundation
import SwiftUI

/// To-Do
///  - When pressed Enter then save mixer thing

struct iOSConfigView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    @State var mixerPage: Int = 0
    @State var isSheetPresented: Bool = false
    var body: some View {
        NavigationStack {
            MixerView(workspace: $workspace, websocket: $websocket, packet: $packet, mixerPage: $mixerPage)
            .tabItem {
                Image(systemName: "slider.vertical.3")
                if packet.mixer.isMixerAvailable == "true" {
                    Text("Mixer")
                } else {
                    Text("Mixer (Disconnected)")
                }
            }
        }
        .toolbar(content: {
            HStack {
                Button {
                    if mixerPage > 0 {
                        mixerPage = mixerPage - 1
                    }
                } label: {
                    Text("Down")
                }
                .disabled(mixerPage == 0)
                .padding(.horizontal)
                Button {
                    isSheetPresented.toggle()
                } label: {
                    Text("Selected Page: \(mixerPage + 1)")
                }
                .buttonStyle(.plain)
                Button {
                    if $mixerPage.wrappedValue != $packet.mixer.pages.wrappedValue.count - 1 {
                        mixerPage = mixerPage + 1
                    } else {
                        websocket.sendNonBindingString("{ \"newPage\": \"true\" }", response: true) //Append Page
                        if $mixerPage.wrappedValue != $packet.mixer.pages.wrappedValue.count - 1 {
                            mixerPage = mixerPage + 1
                        }
                    }
                } label: {
                    if $mixerPage.wrappedValue != $packet.mixer.pages.wrappedValue.count - 1 {
                        Text("Up")
                    } else {
                        Text("New")
                    }
                }
                .padding(.horizontal)
            }
        })
        .sheet(isPresented: $isSheetPresented, content: {
            PagesOverview(workspace: $workspace, websocket: $websocket, packet: $packet, mixerPage: $mixerPage, isSheetPresented: $isSheetPresented)
        })
    }
}

struct PagesOverview: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    @Binding var mixerPage: Int
    @Binding var isSheetPresented: Bool
    var body: some View {
        NavigationStack {
            VStack {
                List(packet.mixer.pages.indices, id: \.self) { index in
                    Button {
                        isSheetPresented = false
                        mixerPage = index
                    } label: {
                        Text("Page \(index + 1)")
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            websocket.sendNonBindingString("{ \"deletePage\": \"\(packet.mixer.pages[index].id)\" }", response: true) //Delete Page
                            if index != 0 {
                                mixerPage = index - 1
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .disabled(!(packet.mixer.pages.count > 1))
                    }
                    .tint(.primary)
                }
                .navigationTitle("Pages")
                .toolbar(content: {
                    Button {
                        websocket.sendNonBindingString("{ \"newPage\": \"true\" }", response: true) //Append Page
                    } label: {
                        Image(systemName: "plus")
                    }
                })
            }
        }
    }
}

struct MixerView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    @Binding var mixerPage: Int
    var body: some View {
        NavigationStack {
            if !packet.mixer.pages.isEmpty {
                VStack {
                    ZStack {
                        if workspace.displayMode != 2 {
                            AngularGradient(gradient: Gradient(colors: [hexStringToRGB(hex: packet.mixer.color), Color(.systemBackground)]), center: .center, startAngle: .degrees(0), endAngle:
                                    .degrees(360))
                            Rectangle()
                                .fill(.clear)
                                .background(Material.bar)
                        }
                        ScrollView {
                            VStack {
                                if packet.mixer.pages[mixerPage].faders != [] { //Error
                                    VStack {
                                        Text("Faders")
                                            .font(.system(.title, weight: .bold))
                                            .padding(.leading, 20)
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(packet.mixer.pages[mixerPage].faders.indices, id: \.self) { index in
                                                    NavigationLink(destination: InformationView(workspace: $workspace, websocket: $websocket, packet: $packet, content: Binding.constant(packet.mixer.pages[mixerPage].faders[index])), label: { SingleFaderView(fader: $packet.mixer.pages[mixerPage].faders[index]) })
                                                        .buttonStyle(.plain)
                                                }
                                                .padding(.leading)
                                            }
                                        }
                                    }
                                }
                                if packet.mixer.pages[mixerPage].buttons != [] {
                                    VStack {
                                        Text("Buttons")
                                            .font(.system(.title, weight: .bold))
                                            .padding(.leading, 20)
                                        ScrollView(.horizontal) {
                                            HStack {
                                                ForEach(packet.mixer.pages[mixerPage].buttons.indices, id: \.self) { index in
                                                    NavigationLink(destination: InformationView(workspace: $workspace, websocket: $websocket, packet: $packet, content: Binding.constant(packet.mixer.pages[mixerPage].buttons[index])), label: { SingleButtonView(button: $packet.mixer.pages[mixerPage].buttons[index]) })
                                                        .buttonStyle(.plain)
                                                }
                                                .padding(.leading)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
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
}

struct SingleFaderView: View {
    @Binding var fader: MixerFader
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.quaternaryLabel))
                .frame(width: 120, height: 300)
                .clipped()
            VStack {
                Text(fader.name)
                    .frame(width: 110, height: 45)
                    .clipped()
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(hex: fader.color) ?? .white)
                    .frame(width: 106, height: 190)
                    .clipped()
                Text(fader.value)
                    .frame(width: 110, height: 26)
                    .clipped()
            }
            .frame(width: 110, height: 280, alignment: .top)
            .clipped()
        }
    }
}

struct SingleButtonView: View {
    @Binding var button: MixerButton
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.quaternaryLabel))
                .frame(width: 120, height: 120)
                .clipped()
            VStack {
                Text(button.name)
                    .frame(width: 110, height: 45)
                    .clipped()
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(hex: button.color) ?? .white)
                    .frame(width: 106, height: 50)
                    .clipped()
            }
            .frame(width: 110, height: 110, alignment: .center)
            .clipped()
        }
    }
}

struct InformationView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    @Binding var content: Any
    
    @State private var bgColor = Color(.sRGB, red: 1.0, green: 1.0, blue: 1.0)
    @State private var localMixerFader: MixerFader = MixerFader(name: "error in InformationView", color: "error in InformationView", isTouched: "error in InformationView", value: "error in InformationView", assignedType: "error in InformationView", assignedID: "error in InformationView", id: "error")
    @State private var localMixerButton: MixerButton = MixerButton(name: "error in InformationView", color: "InformationView", isPressed: "error in InformationView", assignedType: "error in InformationView", assignedID: "error in InformationView", id: "error")
    
    var body: some View {
        if let mixerFader = content as? MixerFader {
            VStack {
                HStack {
                    SingleFaderView(fader: $localMixerFader)
                        .padding(.horizontal, 40)
                    List {
                        TextField("Name", text: $localMixerFader.name)
                        ColorPicker("Color", selection: $bgColor)
                            .onChange(of: bgColor, {
                                let newLocalMixerFader = MixerFader(name: localMixerFader.name, color: rgbToHexString(color: bgColor), isTouched: localMixerFader.isTouched, value: localMixerFader.value, assignedType: localMixerFader.assignedType, assignedID: localMixerFader.assignedID, id: localMixerFader.id)
                                localMixerFader = newLocalMixerFader
                            })
                    }
                    .navigationTitle(localMixerFader.name)
                }
            }
            .onAppear {
                workspace.columnVisible = .detailOnly
                localMixerFader = mixerFader
                bgColor = hexStringToRGB(hex: mixerFader.color)
            }
            .onDisappear {
                saveChanges()
                workspace.columnVisible = .all
            }
            .toolbar(content: {
                Button {
                    saveChanges()
                } label: {
                    Text("Save")
                }
            })
        } else if let mixerButton = content as? MixerButton {
            Text("Button")
                .onAppear {
                    workspace.columnVisible = .detailOnly
                    localMixerButton = mixerButton
                }
                .onDisappear {
                    workspace.columnVisible = .all
                }
        } else {
            Text("Unable to identify Element")
        }
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

    
    func saveChanges() {
        websocket.sendNonBindingString(JsonModule().encodeEditMixerFader(editMixerFader(editMixerFader: hiJuDasIstEineMixerFaderVeränderung(fader: $localMixerFader.wrappedValue))) ?? "", response: true)
    }
}
