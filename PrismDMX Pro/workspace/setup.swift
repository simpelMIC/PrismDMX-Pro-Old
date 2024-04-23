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
            .frame(minWidth: 180, idealWidth: 220, maxWidth: 300)
            currentSetupWindow(selected: $selectedSetupPage, fixtures: $workspace.fixtures, fixtureTemplates: $workspace.fixtureTemplates, websocket: $websocket)
        }
    }
}

struct currentSetupWindow: View {
    @Binding var selected: String?
    @Binding var fixtures: [Fixture]
    @Binding var fixtureTemplates: [fixtureTemplate]
    @Binding var websocket: Websocket
    var body: some View {
        if selected == nil {
            Text("Nothing selected")
        } else if selected == "fixtureConfiguration" {
            FixtureConfigView(fixtures: $fixtures, fixtureTemplates: $fixtureTemplates, websocket: $websocket)
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
    @Binding var fixtures: [Fixture]
    @Binding var fixtureTemplates: [fixtureTemplate]
    @State private var isSheetOpened: Bool = false
    @State private var selectedIndex: Int = 0
    @State private var startChannel: String = ""
    
    @Binding var websocket: Websocket
    
    var selectedTemplate: fixtureTemplate {
        return fixtureTemplates[selectedIndex]
    }
    
    var body: some View {
        VStack {
            Text("Fixture Management")
                .padding(.top)
            Button {
                isSheetOpened = true
                startChannel = "1"
            } label: {
                Text("New Fixture")
            }
            List(fixtures.indices, id: \.self) { index in
                Text(fixtures[index].name)
            }
            .padding()
        }
        .sheet(isPresented: $isSheetOpened) {
            VStack {
                Text("New Fixture")
                Text("Choose from a template below")
                Picker("Select a template", selection: $selectedIndex) {
                    ForEach(fixtureTemplates.indices, id: \.self) { index in
                        Text(fixtureTemplates[index].name)
                    }
                }
                HStack {
                    Text("Starting Address")
                    TextField("startChannel", text: $startChannel)
                }
                .pickerStyle(.menu)
                HStack {
                    Button {
                        isSheetOpened = false
                    } label: {
                        Text("Cancel")
                    }
                    Button {
                        fixtures.append(Fixture(internalID: "0", name: selectedTemplate.name, FixtureGroup: "", template: selectedTemplate.internalID, startChannel: $startChannel.wrappedValue))
                        isSheetOpened = false
                        websocket.sendNonBindingString(JSON().encode(fixtures), response: true)
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


