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
        if $packet.mixer.isMixerAvailable.wrappedValue == "true" {
            if $packet.setup.wrappedValue == "true" {
                NavigationView {
                    iOSSetup(workspace: $workspace, websocket: $websocket, packet: $packet)
                }
            } else if $packet.channels.wrappedValue == "true" {
                iOSChannelsView(workspace: $workspace, websocket: $websocket, packet: $packet, iPadNumber: "left")
            } else {
                NavigationStack {
                    MixerView(workspace: $workspace, websocket: $websocket, packet: $packet, mixerPage: $mixerPage)
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
                        .navigationTitle(packet.project?.name ?? "Untitled Project")
                }
            }
        } else {
            NavigationStack {
                TabView {
                    MixerView(workspace: $workspace, websocket: $websocket, packet: $packet, mixerPage: $mixerPage)
                        .tabItem {
                            Image(systemName: "slider.vertical.3")
                            Text("Mixer")
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
                    NavigationView {
                        iOSSetup(workspace: $workspace, websocket: $websocket, packet: $packet)
                    }
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Setup")
                    }
                }
            }
        }
    }
}
