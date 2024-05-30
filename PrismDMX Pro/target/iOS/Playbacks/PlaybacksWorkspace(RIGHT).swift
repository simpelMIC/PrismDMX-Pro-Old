//
//  PlaybacksWorkspace.swift
//  PrismDMX Pro
//
//  Created by Christian on 06.05.24.
//

import Foundation
import SwiftUI

struct PlaybacksWorkspace: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    var body: some View {
        if $packet.mixer.isMixerAvailable.wrappedValue == "true" {
            if $packet.setup.wrappedValue == "true" {
                NavigationView {
                    iOSSetup(workspace: $workspace, websocket: $websocket, packet: $packet)
                }
            } else if $packet.channels.wrappedValue == "true" {
                iOSChannelsView(workspace: $workspace, websocket: $websocket, packet: $packet, iPadNumber: "right")
            } else {
                PlaybackTimelineView()
            }
        } else {
            TabView {
                PlaybackTimelineView()
                    .tabItem { Text("Playbacks") }
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

struct PlaybackTimelineView: View {
    var body: some View {
        VStack {
            PlaybackInformationView()
            PlaybackTimeline()
            PlaybackTimelineToolbar()
        }
    }
}

struct PlaybackInformationView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    PlaybacksListView()
                } label: {
                    Text("Playbacks")
                }

            }
            .navigationTitle("Playbacks")
        }
    }
}

struct PlaybacksListView: View {
    var body: some View {
        Text("Playbacks")
    }
}

struct PlaybackTimeline: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.tertiary)
            VStack {
                PlaybackTimelineLights()
                PlaybackTimelineAudio()
            }
        }
    }
}

struct PlaybackTimelineLights: View {
    var body: some View {
        ScrollView {
            Text("Lights")
        }
    }
}

struct PlaybackTimelineAudio: View {
    var body: some View {
        ScrollView {
            Text("Audio")
        }
    }
}

struct PlaybackTimelineToolbar: View {
    var body: some View {
        HStack {
            
        }
    }
}
