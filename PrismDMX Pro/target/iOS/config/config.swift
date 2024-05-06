//
//  config.swift
//  PrismDMX Pro
//
//  Created by Christian on 01.05.24.
//

import Foundation
import SwiftUI

///#TODO:
///- An overview of all pages
///- Delete and add pages
struct iOSConfigView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    @State var mixerPage: Int = 0
    @State var isSheetPresented: Bool = false
    var body: some View {
        TabView {
            MixerView(workspace: $workspace, websocket: $websocket, packet: $packet, mixerPage: $mixerPage)
            .tabItem {
                Image(systemName: "slider.vertical.3")
                Text("Mixer")
            }
        }
        .toolbar(content: {
            HStack {
                Button {
                    if mixerPage > 0 {
                        mixerPage = mixerPage - 1
                    }
                } label: {
                    Image(systemName: "minus")
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
                        print(packet.mixer.pages.count)
                    } else {
                        //Append new page
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .disabled($mixerPage.wrappedValue == $packet.mixer.pages.wrappedValue.count - 1)
                .padding(.horizontal)
            }
        })
        .sheet(isPresented: $isSheetPresented, content: {
            PagesOverview()
        })
    }
}

struct PagesOverview: View {
    var body: some View {
        Text("Pages")
    }
}

struct MixerView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    @Binding var mixerPage: Int
    var body: some View {
        if !packet.mixer.pages.isEmpty {
            VStack {
                ZStack {
                    if workspace.displayMode != 2 {
                        AngularGradient(gradient: Gradient(colors: [Color(.sRGB, red: 254/255, green: 254/255, blue: 254/255), Color(.systemBackground)]), center: .center, startAngle: .degrees(0), endAngle:
                                .degrees(360))
                        Rectangle()
                            .fill(.clear)
                            .background(Material.bar)
                    }
                    ScrollView {
                        VStack {
                            if packet.mixer.pages[mixerPage].faders != [] {
                                VStack {
                                    Text("Faders")
                                        .font(.system(.title, weight: .bold))
                                        .padding(.leading, 20)
                                    ScrollView(.horizontal) {
                                        HStack {
                                            ForEach(packet.mixer.pages[mixerPage].faders.indices, id: \.self) { index in
                                                SingleFaderView(fader: $packet.mixer.pages[mixerPage].faders[index])
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
                                                SingleButtonView(button: $packet.mixer.pages[mixerPage].buttons[index])
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
