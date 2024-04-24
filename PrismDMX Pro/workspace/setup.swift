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
    @Binding var packet: packet
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    Button {
                        workspace.isCompleted = false
                    } label: {
                        Text("Network Settings")
                    }
                    .padding(.top)
                    .buttonStyle(.accessoryBar)
                    Button {
                        selectedSetupPage = "fixtureConfiguration"
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
    @Binding var packet: packet
    @Binding var websocket: Websocket
    var body: some View {
        if selected == nil {
            Text("Nothing selected")
        } else if selected == "fixtureConfiguration" {
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
    @Binding var packet: packet
    @Binding var websocket: Websocket
    
    @State private var isSheetOpened: Bool = false
    var body: some View {
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
                Text(packet.fixtures[index].name)
            }
            .padding()
        }
        .sheet(isPresented: $isSheetOpened, content: {
            newFixtureView(packet: $packet, websocket: $websocket, isSheetPresented: $isSheetOpened)
        })
    }
}

struct newFixtureView: View {
    @Binding var packet: packet
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
                    requestNewFixture(newFixture(newFixture: hiJuDasIstEineNeueFixture(fixture: Fixture(internalID: "", name: selectedTemplate.name, FixtureGroup: group, template: selectedTemplate.internalID, startChannel: startChannel))), websocket: $websocket)
                } label: {
                    Text("Create")
                }
            }
        }
        .padding()
    }
    
    func requestNewFixture(_ newFixture: newFixture, websocket: Binding<Websocket>) {
        let json = JsonModule()
        let jsonData = json.encode(newFixture)
        websocket.wrappedValue.sendNonBindingString(jsonData ?? "", response: true)
    }
}
