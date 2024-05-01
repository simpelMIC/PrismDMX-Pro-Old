//
//  fixturesWorkspace.swift
//  PrismDMX Pro
//
//  Created by Christian on 01.05.24.
//

import Foundation
import SwiftUI

struct iOSFixturesView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        TabView {
            iOSFixtureList(workspace: $workspace, websocket: $websocket, packet: $packet)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Fixtures")
                }
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

struct iOSFixtureList: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Fixtures")
                        .font(.system(.title, weight: .bold))
                        .padding(.leading, 20)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(packet.fixtures.sorted(by: { $0.startChannel < $1.startChannel }).indices, id: \.self) { index in
                                NavigationLink {
                                    FixtureControlView()
                                } label: {
                                    SingleFixtureKastenView(fixture: $packet.fixtures[index])
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 220)
                        .clipped()
                    }
                    Text("Fixture Groups")
                        .font(.system(.title, weight: .bold))
                        .padding(.leading, 20)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach($packet.fixtureGroups.indices, id: \.self) { index in
                                SingleFixtureGroupKastenView(fixtureGroup: $packet.fixtureGroups[index])
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(height: 220)
                        .clipped()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.vertical, 20)
                .clipped()
            }
        }
    }
}

struct SingleFixtureKastenView: View {
    @Binding var fixture: Fixture
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color(.quaternaryLabel), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(.quaternaryLabel)))
                .frame(width: 180, height: 200)
                .clipped()
                .shadow(radius: 10)
            VStack {
                Text(fixture.name)
                    .font(.system(.title2, weight: .semibold))
                    .frame(width: 170, height: 60)
                    .clipped()
                Text("Channel: \(fixture.startChannel)")
                .frame(width: 170, height: 20)
                .clipped()
            }
        }
    }
}

struct SingleFixtureGroupKastenView: View {
    @Binding var fixtureGroup: FixtureGroup
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .stroke(Color(.quaternaryLabel), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color(.quaternaryLabel)))
                .frame(width: 180, height: 200)
                .clipped()
                .shadow(radius: 10)
            VStack {
                Text(fixtureGroup.name)
                    .font(.system(.title2, weight: .semibold))
                    .frame(width: 170, height: 60)
                    .clipped()
            }
        }
    }
}

struct FixtureControlView: View {
    var body: some View {
        Text("Hellooo")
    }
}
