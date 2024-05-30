//
//  fixtureGroupManagement.swift
//  PrismDMX Pro
//
//  Created by Christian on 30.05.24.
//

import Foundation
import SwiftUI

struct FixtureGroupConfigView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    private let adaptiveColumn = [
            GridItem(.adaptive(minimum: 180))
        ]
    
    @State var isSheetPresented: Bool = false
    @State var localSheetFixtureGroup: FixtureGroup = FixtureGroup(name: "New Group", groupID: "", internalIDs: [])
    
    var body: some View {
        VStack {
            ScrollView() {
                HStack {
                    LazyVGrid(columns: adaptiveColumn, spacing: 25) {
                        ForEach(packet.fixtureGroups.indices, id: \.self) { index in
                            NavigationLink {
                                FixtureGroupDetailView(fixtureGroup: $packet.fixtureGroups[index], packet: $packet, websocket: $websocket)
                            } label: {
                                FixtureGroupStackView(fixtureGroup: $packet.fixtureGroups[index], packet: $packet)
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                Button(role: .destructive) {
                                    websocket.sendNonBindingString("{\"deleteGroup\": {\"groupID\":\"\(packet.fixtureGroups[index].groupID)\"}}", response: true)
                                } label: {
                                    Text("Delete")
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Fixture Groups")
        .toolbar {
            Button {
                isSheetPresented.toggle()
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $isSheetPresented, content: {
            VStack {
                Text("New Fixture Group")
                    .font(.title)
                    .fontWeight(.black)
                HStack {
                    Text("Name: ")
                    TextField("Name", text: $localSheetFixtureGroup.name)
                }
                Spacer()
                HStack {
                    Button {
                        websocket.sendNonBindingString("{\"newGroup\": {\"groupName\":\"\($localSheetFixtureGroup.name.wrappedValue)\"}}", response: true)
                        isSheetPresented.toggle()
                    } label: {
                        Text("Create")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(20)
        })
    }
}
