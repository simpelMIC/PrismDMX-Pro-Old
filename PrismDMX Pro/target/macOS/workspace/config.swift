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
