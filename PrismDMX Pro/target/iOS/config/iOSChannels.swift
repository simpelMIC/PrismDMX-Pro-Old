//
//  iOSChannels.swift
//  PrismDMX Pro
//
//  Created by Christian on 30.05.24.
//

import Foundation
import SwiftUI

struct iOSChannelsView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    @State var iPadNumber: String
    var body: some View {
        if iPadNumber == "left" { //Left
            if packet.selectedFixtureIDs == [] && packet.selectedFixtureGroupIDs == [] {
                Text("Nothing selected")
                    .font(.headline)
            } else {
                FixtureView(workspace: $workspace, websocket: $websocket, packet: $packet)
            }
        } else { //Right
            if packet.selectedFixtureIDs == [] && packet.selectedFixtureGroupIDs == [] {
                Text("Nothing selected")
                    .font(.headline)
            } else {
                
            }
        }
    }
}

struct SingleFixtureView: View {
    @Binding var fixture: Fixture
    @Binding var packet: Packet
    var body: some View {
        ZStack {
            if $packet.selectedFixtureIDs.wrappedValue.contains($fixture.internalID.wrappedValue) {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .frame(width: 180, height: 180)
                    .clipped()
                    .foregroundColor(.purple)
                    .rotationEffect(.degrees(0), anchor: .center)
            } else {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .frame(width: 180, height: 180)
                    .clipped()
                    .foregroundColor(Color(.tertiaryLabel))
                    .rotationEffect(.degrees(0), anchor: .center)
            }
            VStack {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 70, weight: .regular, design: .default))
                Text($fixture.name.wrappedValue)
                    .padding()
                    .frame(width: 170, height: 20)
            }
        }
    }
}
