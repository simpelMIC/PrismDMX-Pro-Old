//
//  setup.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation
import SwiftUI

struct Setup: View {
    @Binding var workspace: Workspace
    @State var selectedSetupPage: String?
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    Button {
                        workspace.isCompleted = false
                        websocket.disconnect(response: true)
                    } label: {
                        Text("Network Settings")
                    }
                    .padding(.top)
                    .buttonStyle(.accessoryBar)
                    Button {
                        selectedSetupPage = "1"
                    } label: {
                        Text("Fixture Configuration")
                    }
                    .buttonStyle(.accessoryBar)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 180, idealWidth: 220, maxWidth: 300, alignment: .topLeading)
            currentSetupWindow(selected: $selectedSetupPage, packet: $packet, websocket: $websocket)
        }
    }
}

struct currentSetupWindow: View {
    @Binding var selected: String?
    @Binding var packet: Packet
    @Binding var websocket: Websocket
    var body: some View {
        if selected == nil {
            Text("Nothing selected")
        } else if selected == "1" {
            FixtureConfigView(packet: $packet, websocket: $websocket)
        }
    }
}

struct DisableIsCompleted: View {
    @Binding var isCompleted: Bool
    var body: some View {
        Text("Loading...")
            .onAppear {
                isCompleted = false
            }
    }
}

struct FixtureConfigView: View {
    @Binding var packet: Packet
    @Binding var websocket: Websocket
    
    @State private var isSheetOpened: Bool = false
    var body: some View {
        NavigationStack {
            VStack {
                Text("Fixture Configuration")
                    .font(.title)
                    .padding(.top)
                HStack {
                    Button {
                        isSheetOpened = true
                    } label: {
                        Text("New Fixture")
                    }
                }
                List(packet.fixtures.indices, id: \.self) { index in
                    NavigationLink(destination: SingleFixtureConfigView(fixture: $packet.fixtures[index], websocket: $websocket)) {
                        Text(packet.fixtures[index].name)
                    }
                }
                .padding()
            }
            .sheet(isPresented: $isSheetOpened, content: {
                newFixtureView(packet: $packet, websocket: $websocket, isSheetPresented: $isSheetOpened)
            })
        }
    }
}

struct newFixtureView: View {
    @Binding var packet: Packet
    @Binding var websocket: Websocket
    @Binding var isSheetPresented: Bool
    
    @State private var selection: fixtureTemplate?
    @State private var selectedIndex: Int = 0
    @State private var group: String = ""
    @State private var startChannel: String = ""
    
    private var selectedTemplate: fixtureTemplate {
        return packet.fixtureTemplates[selectedIndex]
    }

    var body: some View {
        VStack {
            Text("New Fixture")
            Picker("Pick a template", selection: $selectedIndex) {
                ForEach(packet.fixtureTemplates.indices, id: \.self) { index in
                    Text(packet.fixtureTemplates[index].name)
                }
            }
            HStack {
                Text("Group Identifier")
                TextField("Group ID", text: $group)
            }
            HStack {
                Text("Starting Channel")
                TextField("Channel", text: $startChannel)
            }
            HStack {
                Button {
                    isSheetPresented = false
                } label: {
                    Text("Cancel")
                }
                Button {
                    isSheetPresented = false
                    requestNewFixture(newFixture(newFixture: hiJuDasIstEineNeueFixture(fixture: Fixture(internalID: "", name: selectedTemplate.name, FixtureGroup: group, template: selectedTemplate.internalID, startChannel: startChannel, channels: selectedTemplate.channels))), websocket: $websocket)
                } label: {
                    Text("Create")
                }
            }
        }
        .padding()
    }
    
    func requestNewFixture(_ newFixture: newFixture, websocket: Binding<Websocket>) {
        let json = JsonModule()
        let jsonData = json.encodeNewFixture(newFixture)
        websocket.wrappedValue.sendNonBindingString(jsonData ?? "", response: true)
    }
}

/*
 struct Channel: Equatable, Codable, Hashable {
     var internalID: String
     var ChannelName: String
     var ChannelType: String
     var dmxChannel: String
 }
 */

struct SingleFixtureConfigView: View {
    @Binding var fixture: Fixture
    @Binding var websocket: Websocket
    var body: some View {
        NavigationStack {
            TabView {
                FixtureGeneralView(fixture: $fixture)
                    .tabItem {
                        Text("General")
                    }
                    .padding(12)
                ChannelView(channels: $fixture.channels)
                    .tabItem {
                        Text("Channels")
                    }
            }
        }
        .toolbar(content: {
            Button {
                sendEditedFixture()
            } label: {
                Text("Save")
            }
        })
        .padding(12)
        .onDisappear {
            sendEditedFixture()
        }
    }
    
    func sendEditedFixture() {
        websocket.sendNonBindingString(JsonModule().encodeEditFixture(editFixture(editFixture: hiJuDasIstEineNeueFixture(fixture: $fixture.wrappedValue))) ?? "", response: true)
    }
}

struct ChannelWrapper: Identifiable {
    var id: UUID
    var channel: Channel
}

struct ChannelView: View {
    @Binding var channels: [Channel]

    var body: some View {
        Table(channels.map { ChannelWrapper(id: UUID(), channel: $0) }) {
            TableColumn("Name", value: \.channel.ChannelName)
            TableColumn("Type", value: \.channel.ChannelType)
            TableColumn("Address", value: \.channel.dmxChannel)
        }
    }
}

/*
 struct Fixture: Equatable, Codable {
     var internalID: String
     var name: String
     var FixtureGroup: String
     var template: String
     var startChannel: String
     var channels: [Channel]
 }
 */

struct FixtureGeneralView: View {
    @Binding var fixture: Fixture
    var body: some View {
        ScrollView {
            VStack {
                Text("General")
                    .font(.title)
                    .fontWeight(.black)
                HStack {
                    Text("Name")
                    TextField("Name", text: $fixture.name)
                }
                HStack {
                    Text("Group")
                    TextField("Group", text: $fixture.FixtureGroup)
                }
                HStack {
                    Text("Start Channel")
                    TextField("Start Channel", text: $fixture.FixtureGroup)
                }
            }
        }
    }
}
