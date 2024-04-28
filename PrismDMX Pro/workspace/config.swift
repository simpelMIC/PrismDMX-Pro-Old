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
    var faders: [MixerFader]
    var buttons: [MixerButton]
    var color: String
    var page: String
    var isMixerAvailable: String //Bool
    var mixerType: String //Divides between 5/10/15 .. mixers
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
    @Binding var mixer: Mixer
    var body: some View {
        TabView {
            GroupsView()
                .tabItem {
                    Text("Groups")
                }
            MixerConfigView(mixer: $mixer)
                .tabItem {
                    Text("Mixer")
                }
        }
    }
}

struct GroupsView: View {
    var body: some View {
        VStack {
            Text("Groups")
        }
    }
}

struct MixerConfigView: View {
    @Binding var mixer: Mixer
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, content: {
                Text("Fader")
                    .font(.title)
                ScrollView(.horizontal) {
                    HStack {
                        HStack {
                            ForEach(mixer.faders.indices, id: \.self) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .frame(width: 140, height: 160)
                                        .clipped()
                                }
                            }
                        }
                    }
                }
                Text("PrismSpinner")
                    .font(.title)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(mixer.faders.indices, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .frame(width: 140, height: 160)
                                            .clipped()
                            }
                        }
                    }
                }
                Text("Buttons")
                    .font(.title)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(mixer.buttons.indices, id: \.self) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                            .frame(width: 140, height: 160)
                                            .clipped()
                            }
                        }
                    }
                }
            })
            .padding(12)
        }
    }
}
