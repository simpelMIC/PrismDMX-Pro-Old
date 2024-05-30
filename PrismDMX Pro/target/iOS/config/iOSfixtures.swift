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
    
    private let adaptiveColumn = [
            GridItem(.adaptive(minimum: 180))
        ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("Fixture Groups")
                            .font(.headline)
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            LazyHGrid(rows: adaptiveColumn, spacing: 25) {
                                ForEach(packet.fixtureGroups.indices, id: \.self) { index in
                                    Button {
                                        if $packet.selectedFixtureGroupIDs.wrappedValue.contains($packet.fixtureGroups[index].groupID.wrappedValue) {
                                            websocket.sendNonBindingString("{\"deselectFixtureGroup\":{\"groupID\":\"\($packet.fixtureGroups[index].groupID.wrappedValue)\"}}", response: true)
                                        } else {
                                            websocket.sendNonBindingString("{\"selectFixtureGroup\":{\"groupID\":\"\($packet.fixtureGroups[index].groupID.wrappedValue)\"}}", response: true)
                                        }
                                    } label: {
                                        FixtureGroupStackView(fixtureGroup: $packet.fixtureGroups[index], packet: $packet)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    HStack {
                        Text("Fixtures")
                            .font(.headline)
                    }
                    LazyVGrid(columns: adaptiveColumn, spacing: 25) {
                        ForEach($packet.fixtures.indices, id: \.self) { index in
                            Button {
                                if $packet.selectedFixtureIDs.wrappedValue.contains($packet.fixtures[index].internalID.wrappedValue) {
                                    websocket.sendNonBindingString("{\"deselectFixture\":{\"fixtureID\":\"\($packet.fixtures[index].internalID.wrappedValue)\"}}", response: true)
                                } else {
                                    websocket.sendNonBindingString("{\"selectFixture\":{\"fixtureID\":\"\($packet.fixtures[index].internalID.wrappedValue)\"}}", response: true)
                                }
                            } label: {
                                SingleFixtureView(fixture: $packet.fixtures[index], packet: $packet)
                            }
                            .buttonStyle(.plain)
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
    @Binding var packet: Packet
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
                if $packet.channels.wrappedValue == "true" {
                    if $packet.selectedFixtureGroupIDs.wrappedValue.contains(fixtureGroup.groupID) {
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
                } else {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .frame(width: 180, height: 180)
                        .clipped()
                        .foregroundColor(Color(.tertiaryLabel))
                        .rotationEffect(.degrees(0), anchor: .center)
                }
                VStack {
                    Text($fixtureGroup.name.wrappedValue)
                        .frame(width: 160, height: 70)
                        .clipped()
                        .font(.system(.body, weight: .bold))
                }
            }
        }
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
                        Button {
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
