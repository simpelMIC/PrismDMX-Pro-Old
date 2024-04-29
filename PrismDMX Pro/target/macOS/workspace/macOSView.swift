//
//  macOSView.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation
import SwiftUI

enum SideBarItem: String, Identifiable, CaseIterable {
    var id: String { rawValue }
    
    case setup
    case config
    case playbacks
}

struct loadingMainView: View {
    @State var websocket: Websocket
    
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var packet: Packet
    @Binding var workspace: Workspace
    var body: some View {
        VStack {
            if workspace.isCompleted == true {
                if connected == false && error == nil {
                    ConnectingView(websocket: $websocket)
                        .onAppear {
                            connect()
                        }
                } else if connected == false && error != nil {
                    ErrorView(connected: $connected, error: $error, websocket: $websocket, workspace: $workspace)
                } else if connected == true && error != nil {
                    ErrorView(connected: $connected, error: $error, websocket: $websocket, workspace: $workspace)
                } else if connected == true && error == nil {
                    ProjectView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
                }
            } else {
                NWConfigView(workspace: $workspace, connected: $connected, error: $error)
            }
        }
        .onDisappear {
            websocket.disconnect(response: true)
        }
    }
    
    func connect() {
        websocket.connect(ip: $workspace.settings.ip, port: $workspace.settings.port, response: true)
    }
}

struct ProjectView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    
    var body: some View {
        VStack {
            if workspace.settings.project == nil {
                if packet.project == nil || packet.project == Project(internalID: "na", name: "na") {
                    setProjectView(packet: $packet, workspace: $workspace, websocket: $websocket)
                } else {
                WorkspaceView(workspace: $workspace, websocket: $websocket, packet: $packet) //If a new Project is created
                        //.onAppear {
                        //    workspace.settings.project = packet.project
                        //}
                }
            } else {
                if packet.project == nil || packet.project == Project(internalID: "na", name: "na") {
                    setProjectView(packet: $packet, workspace: $workspace, websocket: $websocket)
                        .onAppear {
                            loadProject()
                        }
                } else {
                    WorkspaceView(workspace: $workspace, websocket: $websocket, packet: $packet) //If an existing project is loaded
                }
            }
        }
        .toolbar(content: {
            if packet.project == nil || packet.project == Project(internalID: "na", name: "na") {
                Text("No project selected")
            } else {
                Text("Current selected project: \(packet.project?.name ?? "No project selected")")
            }
        })
    }
    
    func loadProject() {
        websocket.sendNonBindingString(JsonModule().encodeSetProject(setProject(setProject: hiJuDasIstEinNeuesProject(project: workspace.settings.project ?? Project(internalID: "na", name: "na")))) ?? "", response: true)
    }
}

struct setProjectView: View {
    @Binding var packet: Packet
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    
    @State private var selectedIndex: Int = 0
    @State private var isSheetPresented: Bool = false
    
    private var sortedProjectIndices: [Int] {
        return packet.availableProjects.indices.sorted { index1, index2 in
            let project1 = packet.availableProjects[index1]
            let project2 = packet.availableProjects[index2]
            return project1.name.contains("(currently open)") && !project2.name.contains("(currently open)")
        }
    }
    
    private var selectedProject: Project {
        let selectedProjectIndex = sortedProjectIndices[selectedIndex]
        return packet.availableProjects[selectedProjectIndex]
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Select your project")
                    .font(.title)
                    .fontWeight(.black)
                HStack {
                    Picker("Available Projects", selection: $selectedIndex) {
                        ForEach(0..<packet.availableProjects.count, id: \.self) { index in
                            Text(packet.availableProjects[self.sortedProjectIndices[index]].name)
                        }
                    }
                    Button("Create") { createProject() }
                        .buttonStyle(.bordered)
                }
                HStack {
                    Button("Load") { loadProject() }
                        .buttonStyle(.borderedProminent)
                }
            }
            .padding(12)
        }
        .sheet(isPresented: $isSheetPresented, content: {
            newProjectSheet(isSheetPresented: $isSheetPresented, websocket: $websocket)
        })
    }
    
    func loadProject() {
        workspace.settings.project = selectedProject
        websocket.sendNonBindingString(JsonModule().encodeSetProject(setProject(setProject: hiJuDasIstEinNeuesProject(project: selectedProject))) ?? "", response: true)
    }
    
    func createProject() {
        isSheetPresented.toggle()
    }
}



struct newProjectSheet: View {
    @State var newProject: Project = Project(internalID: "0", name: "New Project")
    
    @Binding var isSheetPresented: Bool
    @Binding var websocket: Websocket
    
    var body: some View {
        VStack {
            Text("New Project")
                .font(.title)
                .fontWeight(.black)
            HStack {
                Text("Name")
                TextField("Name", text: $newProject.name)
            }
            HStack {
                Button("Cancel") { isSheetPresented.toggle() }
                    .buttonStyle(.bordered)
                Button("Create & Load") {
                    createProject()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(12)
    }
    
    func createProject() {
        isSheetPresented.toggle()
        #if os(macOS)
        websocket.sendNonBindingString(JsonModule().encodeNewProject(PrismDMX_Pro.newProject(newProject: hiJuDasIstEinNeuesProject(project: newProject))) ?? "", response: true)
        #else
        websocket.sendNonBindingString(JsonModule().encodeNewProject(PrismDMX_Pro_Mobile.newProject(newProject: hiJuDasIstEinNeuesProject(project: newProject))) ?? "", response: true)
        #endif
    }
}

struct ConnectingView: View {
    @Binding var websocket: Websocket
    var body: some View {
        VStack {
            Text("Loading")
            Button {
                websocket.disconnect(response: true)
            } label: {
                Text("Cancel")
            }
        }
        .toolbar(content: {
            Text("")
        })
    }
}

struct ErrorView: View {
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    @Binding var workspace: Workspace
    var body: some View {
        VStack {
            Text("An error occured: \(error ?? "Error")")
            Button("Retry") {
                websocket.disconnect(response: true)
                websocket.connect(ip: $workspace.settings.ip, port: $workspace.settings.port, response: true)
            }
            Button("Settings") {
                workspace.isCompleted = false
            }
        }
        .toolbar(content: {
            Text("")
        })
    }
}

struct NWConfigView: View {
    @Binding var workspace: Workspace
    @Binding var connected: Bool
    @Binding var error: String?
    var body: some View {
        VStack {
            Text("Websocket Settings")
                .font(.title)
            TextField("IP", text: $workspace.settings.ip)
            TextField("Port", text: $workspace.settings.port)
            Text("Final Destination Address: \(workspace.settings.ip):\(workspace.settings.port)")
            Spacer()
            Button {
                workspace.isCompleted.toggle()
                connected = false
                error = nil
            } label: {
                Text("Continue")
            }
        }
        .padding()
        .toolbar(content: {
            Text("No server selected")
        })
    }
}
