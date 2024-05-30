//
//  iOSfixtures.swift
//  PrismDMX Pro
//
//  Created by Christian on 29.05.24.
//

import Foundation
import SwiftUI

struct FixtureView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    @State var isSheetPresented: Bool = false
    @State var localSheetName: String = "New Group"
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("Fixture Groups")
                            .font(.headline)
                        Spacer()
                        Button {
                            isSheetPresented.toggle()
                        } label: {
                            Text("Add")
                        }
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(packet.fixtureGroups.indices, id: \.self) { index in
                                NavigationLink {
                                    FixtureGroupDetailView(fixtureGroup: $packet.fixtureGroups[index], packet: $packet, websocket: $websocket)
                                } label: {
                                    FixtureGroupStackView(fixtureGroup: $packet.fixtureGroups[index])
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button {
                                        websocket.sendNonBindingString("{\"deleteGroup\": {\"groupID\":\"\(packet.fixtureGroups[index].groupID)\"}}", response: true)
                                    } label: {
                                        Text("Delete")
                                    }
                                }
                            }
                        }
                    }
                    HStack {
                        Text("Fixtures")
                            .font(.headline)
                        Spacer()
                        NavigationLink {
                        } label: {
                            Text("Settings")
                        }
                    }
                    ForEach($packet.fixtures.indices, id: \.self) { index in
                        NavigationLink {
                            
                        } label: {
                            Text($packet.fixtures[index].name.wrappedValue)
                        }
                    }
                }
            }
            .navigationTitle("Fixtures")
            .padding(20)
        }
        .sheet(isPresented: $isSheetPresented) {
            VStack {
                Text("New Fixture Group")
                    .font(.title)
                    .fontWeight(.black)
                HStack {
                    Text("Name: ")
                    TextField("Name", text: $localSheetName)
                }
                Spacer()
                HStack {
                    Button {
                        isSheetPresented.toggle()
                        websocket.sendNonBindingString("{\"newGroup\": {\"groupName\":\"\($localSheetName.wrappedValue)\"}}", response: true)
                    } label: {
                        Text("Create")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(20)
        }
    }
}

struct FixtureGroupStackView: View {
    @Binding var fixtureGroup: FixtureGroup
    var body: some View {
        ZStack {
            if fixtureGroup.internalIDs.count >= 2 {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .frame(width: 180, height: 180)
                    .clipped()
                    .foregroundColor(Color(.quaternaryLabel))
                    .rotationEffect(.degrees(16), anchor: .center)
            }
            if fixtureGroup.internalIDs.count >= 1 {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .frame(width: 180, height: 180)
                    .clipped()
                    .foregroundColor(Color(.quaternaryLabel))
                    .rotationEffect(.degrees(8), anchor: .center)
            }
            if fixtureGroup.internalIDs.count >= 0 {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .frame(width: 180, height: 180)
                    .clipped()
                    .foregroundColor(Color(.tertiaryLabel))
                    .rotationEffect(.degrees(0), anchor: .center)
                VStack {
                    Text($fixtureGroup.name.wrappedValue)
                        .frame(width: 160, height: 70)
                        .clipped()
                        .font(.system(.body, weight: .bold))
                }
            }
        }
        .padding(20)
    }
}

struct FixtureGroup: Equatable, Codable {
    var name: String
    var groupID: String
    var internalIDs: [String]
}

struct Fixture: Equatable, Codable {
    var internalID: String
    var name: String
    var FixtureGroup: String
    var template: String
    var startChannel: String
    var channels: [Channel]
}

struct FixtureGroupDetailView: View {
    @Binding var fixtureGroup: FixtureGroup
    @Binding var packet: Packet
    @Binding var websocket: Websocket
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("All Fixtures")
                    List (packet.fixtures.filter { !fixtureGroup.internalIDs.contains($0.internalID) }, id: \.internalID) { fixture in
                        Button(role: .destructive) {
                            websocket.sendNonBindingString("{\"addFixtureToGroup\":{\"groupID\":\"\(fixtureGroup.groupID)\", \"fixtureID\":\"\(fixture.internalID)\"}}", response: true)
                        } label: {
                            Text(fixture.name)
                        }
                    }
                }
                VStack {
                    Text("Added Fixtures")
                    List(packet.fixtures.filter { fixtureGroup.internalIDs.contains($0.internalID) }, id: \.internalID) { fixture in
                        Button(role: .destructive) {
                            websocket.sendNonBindingString("{\"removeFixtureFromGroup\":{\"groupID\":\"\(fixtureGroup.groupID)\", \"fixtureID\":\"\(fixture.internalID)\"}}", response: true)
                        } label: {
                            Text(fixture.name)
                        }
                    }
                }
            }
        }
        .navigationTitle(fixtureGroup.name)
    }
}
