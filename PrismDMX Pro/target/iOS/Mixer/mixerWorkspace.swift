//
//  MixerWorkspace.swift
//  PrismDMX Pro
//
//  Created by Christian on 02.05.24.
//

import Foundation
import SwiftUI

struct iOSMixerView: View {
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
                NavigationView {
                    iOSSetup(workspace: $workspace, websocket: $websocket, packet: $packet)
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setup")
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
                PagesOverview(workspace: $workspace, websocket: $websocket, packet: $packet, mixerPage: $mixerPage, isSheetPresented: $isSheetPresented)
            })
        }
    }
}
