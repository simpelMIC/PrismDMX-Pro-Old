//
//  config.swift
//  PrismDMX Pro
//
//  Created by Christian on 27.04.24.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: Int, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: opacity
        )
    }
}

struct Mixer: Equatable, Codable {
    var pages: [MixerPage]
    var color: String
    var isMixerAvailable: String //Bool
    var mixerType: String //Divides between 5/10/15 .. mixers
}

struct MixerPage: Equatable, Codable {
    var num: String
    var faders: [MixerFader]
    var buttons: [MixerButton]
}

struct MixerFader: Equatable, Codable {
    var name: String
    var color: String //HEX f.e. 0xffffff
    var isTouched: String //Bool
    var value: String //Int
    var assignedType: String
    var assignedID: String
}

struct MixerButton: Equatable, Codable {
    var name: String
    var color: String
    var isPressed: String //Bool
    var assignedType: String
    var assignedID: String
}

struct ConfigView: View {
    @Binding var packet: Packet
    var body: some View {
        TabView {
            GroupsView(groups: $packet.fixtureGroups)
                .tabItem {
                    Text("Groups")
                }
            MixerConfigView(mixer: $packet.mixer)
                .tabItem {
                    Text("Mixer")
                }
        }
    }
}

struct GroupsView: View {
    @Binding var groups: [FixtureGroup]
    var body: some View {
        VStack {
        }
    }
}

struct MixerConfigView: View {
    @Binding var mixer: Mixer
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, content: {
            })
            .padding(12)
        }
    }
}
