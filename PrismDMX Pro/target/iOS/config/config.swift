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
                Text("Selected Page \(mixerPage + 1)")
                Button {
                    mixerPage = mixerPage + 1
                } label: {
                    Image(systemName: "plus")
                }
            }
        })
    }
}

struct MixerView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    @Binding var mixerPage: Int
    var body: some View {
        List {/*
            ZStack {
                AngularGradient(gradient: Gradient(colors: [Color(.sRGB, red: 254/255, green: 254/255, blue: 254/255), Color(.systemBackground)]), center: .center, startAngle: .degrees(0), endAngle:
                        .degrees(360))
                Rectangle()
                    .fill(.clear)
                    .background(Material.bar)
                ScrollView {
                    VStack {
                        Text("Faders")
                            .font(.system(.title, weight: .bold))
                            .padding(.leading, 20)
                        HStack {
                            
                        }
                    }
                }
            }*/
            Text("Hello")
        }
    }
}

struct SingleFaderView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(.quaternaryLabel))
                .frame(width: 120, height: 300)
                .clipped()
            VStack {
                Text("hjjjkhgvjknhbuijknbhgujhbghzujnhb")
                    .frame(width: 110, height: 45)
                    .clipped()
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .frame(width: 106, height: 190)
                    .clipped()
                Text("hjjjkhgvjknhbuijknbhgujhbghzujnhb")
                    .frame(width: 110, height: 26)
                    .clipped()
            }
            .frame(width: 110, height: 280, alignment: .top)
            .clipped()
        }
    }
}
