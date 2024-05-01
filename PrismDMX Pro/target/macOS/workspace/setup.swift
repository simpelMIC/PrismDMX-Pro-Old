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
        NavigationStack {
            List {
                NavigationLink(destination: DisableIsCompleted(isCompleted: $workspace.isCompleted), label: { Text("Network Settings") })
                NavigationLink(destination: FixtureConfigView(packet: $packet, websocket: $websocket), label: { Text("Fixture Configuration") })
                NavigationLink(destination: JSONExportView(packet: $packet), label: { Text("JSON Export") })
                NavigationLink(destination: EnterProjectView(workspace: $workspace, packet: $packet), label: { Text("Projects") })
            }
            /*List {
                
                 VStack {
                 Button {
                 workspace.isCompleted = false
                 websocket.disconnect(response: true)
                 } label: {
                 Text("Network Settings")
                 }
                 .padding(.top)
                 .buttonStyle(.bordered)
                 Button {
                 selectedSetupPage = "1"
                 } label: {
                 Text("Fixture Configuration")
                 }
                 .buttonStyle(.bordered)
                 Button {
                 selectedSetupPage = "2"
                 } label: {
                 Text("JSON Export")
                 }
                 .buttonStyle(.bordered)
                 }
                 }
                 .listStyle(SidebarListStyle())
                 .frame(minWidth: 180, idealWidth: 220, maxWidth: 300, alignment: .topLeading)
                 currentSetupWindow(selected: $selectedSetupPage, packet: $packet, websocket: $websocket)
                 
            }*/
        }
        .navigationTitle("Setup")
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
        } else if selected == "2" {
            JSONExportView(packet: $packet)
        }
    }
}

struct JSONExportView: View {
    @State var jsonOutput: String = ""
    @State var buttonText: String = "Copy to clipboard"
    @Binding var packet: Packet
    var body: some View {
        VStack {
            Text(jsonOutput)
            Button {
                jsonOutput = JsonModule().encodePacket($packet.wrappedValue) ?? "Failed to generate"
                buttonText = "Copy to clipboard"
            } label: {
                Text("Generate Json")
            }
            Button {
                #if os(macOS)
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(jsonOutput, forType: .string)
                buttonText = "Copied!"
                #endif
            } label: {
                Text(buttonText)
            }
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

struct EnterProjectView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    var body: some View {
        Text("Loading...")
            .onAppear {
                workspace.project = nil
                packet.project = nil
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
                    .contextMenu(ContextMenu(menuItems: {
                        Button {
                            requestNewFixture(newFixture(newFixture: hiJuDasIstEineNeueFixture(fixture: $packet.fixtures[index].wrappedValue)), websocket: $websocket)
                        } label: {
                            Text("Duplicate")
                        }
                        Button {
                            requestFixtureDeletion(packet.fixtures[index], websocket: $websocket)
                        } label: {
                            Text("Delete")
                        }

                    }))
                }
                .padding()
            }
            .sheet(isPresented: $isSheetOpened, content: {
                newFixtureView(packet: $packet, websocket: $websocket, isSheetPresented: $isSheetOpened)
            })
        }
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
            Picker("Pick a template", selection: $selectedIndex) {
                ForEach(packet.fixtureTemplates.indices, id: \.self) { index in
                    Text(packet.fixtureTemplates[index].name)
                }
            }
            HStack {
                Text("Name")
                TextField("Name", text: Binding(
                                get: { self.name ?? "" },
                                set: { self.name = $0.isEmpty ? nil : $0 }
                            ))
            }
            HStack {
                Text("Starting Channel")
                TextField("Channel", text: $startChannelString)
            }
            HStack {
                Button {
                    isSheetPresented = false
                } label: {
                    Text("Cancel")
                }
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
    @State var localFixture: Fixture = Fixture(internalID: "error", name: "error", FixtureGroup: "error", template: "error", startChannel: "error", channels: [])
    @Binding var websocket: Websocket
    @State var isEditChannelSheetOpened: Bool = false
    
    var body: some View {
        NavigationStack {
            TabView {
                FixtureGeneralView(fixture: $localFixture)
                    .tabItem {
                        Text("General")
                    }
                    .padding(12)
                ChannelView(channels: $localFixture.channels, editChannelSheet: $isEditChannelSheetOpened)
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
        .onAppear {
            localFixture = fixture
        }
        .onDisappear {
            fixture = localFixture
            sendEditedFixture()
        }
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
            HStack {
                Text("Name")
                TextField("Name", text: $internalChannel.ChannelName)
            }
            HStack {
                Text("DMX Channel")
                TextField("", text: $internalChannel.dmxChannel)
            }
            HStack {
                Button {
                    editChannelSheet = false
                } label: {
                    Text("Cancel")
                }
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
        .padding(12)
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
                    Text($fixture.channels.first?.dmxChannel.wrappedValue ?? "n/a")
                }
            }
        }
    }
}
