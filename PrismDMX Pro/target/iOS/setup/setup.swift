//
//  setup.swift
//  PrismDMX Pro_Mobile
//
//  Created by Christian on 30.04.24.
//

import Foundation
import SwiftUI

struct iOSSetup: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        List {
            NavigationLink(destination: iOSSettings(workspace: $workspace, websocket: $websocket, packet: $packet), label: { Text("App Settings") })
            NavigationLink(destination: FixtureConfigView(packet: $packet, websocket: $websocket, fixtures: $packet.fixtures), label: { Text("Fixture Configuration") })
            NavigationLink(destination: iOSMixerConfigView(workspace: $workspace, websocket: $websocket, packet: $packet), label: { Text("Mixer Configuration") })
        }
        .navigationTitle("Setup")
    }
}
