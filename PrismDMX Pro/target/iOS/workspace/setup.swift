//
//  setup.swift
//  PrismDMX Pro_Mobile
//
//  Created by Christian on 30.04.24.
//

import Foundation
import SwiftUI

struct iOSSetup: View {
    @Binding var workspace: Workspace
    @State var selectedSetupPage: String?
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: FixtureConfigView(packet: $packet, websocket: $websocket), label: { Text("Fixture Configuration") })
            }
            .navigationTitle("Setup")
        }
    }
}

struct FixtureConfigView: View {
    @Binding var packet: Packet
    @Binding var websocket: Websocket
    
    @State private var isSheetOpened: Bool = false
    @State private var isActionSheetOpened: Bool = false
    var body: some View {
        VStack {
            List(packet.fixtures.indices, id: \.self) { index in
                NavigationLink(destination: SingleFixtureConfigView(fixture: $packet.fixtures[index], websocket: $websocket)) {
                    Text(packet.fixtures[index].name)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                requestFixtureDeletion(packet.fixtures[index], websocket: $websocket)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                requestNewFixture(newFixture(newFixture: hiJuDasIstEineNeueFixture(fixture: $packet.fixtures[index].wrappedValue)), websocket: $websocket)
                            } label: {
                                Label("Duplicate", systemImage: "square.fill.on.square.fill")
                            }
                        }
                }
            }
            .padding()
            .navigationTitle("Fixture Configuration")
        }
        .toolbar {
            Button {
                isSheetOpened = true
            } label: {
                Image(systemName: "plus")
            }

        }
        .sheet(isPresented: $isSheetOpened, content: {
            newFixtureView(packet: $packet, websocket: $websocket, isSheetPresented: $isSheetOpened)
        })
    }
    
    func requestNewFixture(_ newFixture: newFixture, websocket: Binding<Websocket>) {
        let json = JsonModule()
        let jsonData = json.encodeNewFixture(newFixture)
        websocket.wrappedValue.sendNonBindingString(jsonData ?? "", response: true)
    }
    
    func requestFixtureDeletion(_ fixture: Fixture, websocket: Binding<Websocket>) {
        let json = JsonModule()
        let jsonData = json.encodeFixtureDeletion(DeleteFixture(deleteFixture: hiJuDasIstDieFixture(internalID: fixture.internalID)))
        websocket.wrappedValue.sendNonBindingString((jsonData ?? ""), response: true)
    }
}

struct newFixtureView: View {
    @Binding var packet: Packet
    @Binding var websocket: Websocket
    @Binding var isSheetPresented: Bool
    
    @State private var selection: FixtureTemplate?
    @State private var name: String?
    @State private var selectedIndex: Int = 0
    @State private var group: String = ""
    @State private var startChannelString: String = ""
    
    private var selectedTemplate: FixtureTemplate {
        return packet.fixtureTemplates[selectedIndex]
    }
    
    private var startChannel: Int {
        return Int(startChannelString) ?? 1
    }

    var body: some View {
        VStack {
            Text("New Fixture")
                .font(.title)
                .fontWeight(.black)
            HStack {
                Text("Name: ")
                TextField("Name", text: Binding(
                                get: { self.name ?? "" },
                                set: { self.name = $0.isEmpty ? nil : $0 }
                            ))
            }
            HStack {
                Text("Starting Channel: ")
                TextField("Channel", text: $startChannelString)
            }
            HStack {
                Text("Pick a template: ")
                Picker("Pick a template", selection: $selectedIndex) {
                    ForEach(packet.fixtureTemplates.indices, id: \.self) { index in
                        Text(packet.fixtureTemplates[index].name)
                    }
                }
            }
            Spacer()
            HStack {
                Button {
                    isSheetPresented = false
                    var newChannels = [Channel]()
                    for templateChannel in selectedTemplate.channels {
                        let dmxChannel = "\(startChannel + Int(templateChannel.dmxChannel)! - 1)"
                        newChannels.append(Channel(internalID: String(packet.fixtures.count), ChannelName: templateChannel.ChannelName, ChannelType: templateChannel.ChannelType, dmxChannel: dmxChannel))
                    }
                    requestNewFixture(newFixture(newFixture: hiJuDasIstEineNeueFixture(fixture: Fixture(internalID: "", name: $name.wrappedValue ?? selectedTemplate.name, FixtureGroup: group, template: selectedTemplate.internalID, startChannel: String(startChannel), channels: newChannels))), websocket: $websocket)
                } label: {
                    Text("Create")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
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
    @State var localFixture: Fixture = Fixture(internalID: "error", name: "error", FixtureGroup: "error", template: "error", startChannel: "error", channels: [])
    @Binding var websocket: Websocket
    @State var isEditChannelSheetOpened: Bool = false
    
    var body: some View {
        TabView {
            FixtureGeneralView(fixture: $localFixture)
                .tabItem {
                    Image(systemName: "gear")
                    Text("General")
                }
                .padding(12)
            ChannelView(channels: $localFixture.channels, editChannelSheet: $isEditChannelSheetOpened)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Channels")
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
        .onAppear {
            localFixture = fixture
        }
        .onDisappear {
            fixture = localFixture
            sendEditedFixture()
        }
        .navigationTitle(fixture.name)
    }
    
    public func sendEditedFixture() {
        fixture.startChannel = $fixture.channels.first?.dmxChannel.wrappedValue ?? "n/a"
        websocket.sendNonBindingString(JsonModule().encodeEditFixture(editFixture(editFixture: hiJuDasIstEineNeueFixture(fixture: $fixture.wrappedValue))) ?? "", response: true)
    }
}

struct ChannelWrapper: Identifiable {
    var id: UUID
    var channel: Channel
}

struct ChannelView: View {
    @Binding var channels: [Channel]
    @State var selectedChannel: Channel = Channel(internalID: "42", ChannelName: "error", ChannelType: "error", dmxChannel: "1")
    
    @Binding var editChannelSheet: Bool

    var body: some View {
        Table(channels.map { ChannelWrapper(id: UUID(), channel: $0) }) {
            TableColumn("Name", value: \.channel.ChannelName)
            TableColumn("Type", value: \.channel.ChannelType)
            TableColumn("Address", value: \.channel.dmxChannel)
            TableColumn("Action") { index in
                Button {
                    selectedChannel = index.channel
                    editChannelSheet = true
                } label: {
                    Text("Edit")
                }
                .buttonStyle(.bordered)
                .sheet(isPresented: $editChannelSheet) {
                    editChannelSheetView(channel: $selectedChannel, editChannelSheet: $editChannelSheet)
                        .onDisappear {
                            if let selectedChannelIndex = channels.firstIndex(where: { $0.internalID == selectedChannel.internalID}) {
                                channels[selectedChannelIndex] = $selectedChannel.wrappedValue
                            }
                        }
                }
            }
        }
    }
}

struct editChannelSheetView: View {
    @Binding var channel: Channel
    @Binding var editChannelSheet: Bool
    
    @State var internalChannel: Channel = Channel(internalID: "error", ChannelName: "error", ChannelType: "error", dmxChannel: "error")
    var body: some View {
        VStack {
            Text("Edit channel \(internalChannel.ChannelName)")
                .font(.title)
                .fontWeight(.black)
            HStack {
                Text("Name")
                TextField("Name", text: $internalChannel.ChannelName)
            }
            HStack {
                Text("DMX Channel")
                TextField("", text: $internalChannel.dmxChannel)
            }
            Spacer()
            HStack {
                Button {
                    channel = internalChannel
                    editChannelSheet = false
                } label: {
                    Text("Done")
                }
                .buttonStyle(.borderedProminent)
                .disabled(internalChannel == channel)
            }
        }
        .padding(20)
        .onAppear {
            internalChannel = channel
        }
    }
}

struct FixtureGeneralView: View {
    @Binding var fixture: Fixture
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Name: ")
                    TextField("Name", text: $fixture.name)
                }
                HStack {
                    Text("Start Channel")
                    Text($fixture.channels.first?.dmxChannel.wrappedValue ?? "n/a")
                }
            }
        }
    }
}
