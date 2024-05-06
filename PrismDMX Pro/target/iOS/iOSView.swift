//
//  iOSView.swift
//  PrismDMX Pro
//
//  Created by Christian on 29.04.24.
//

import Foundation
import SwiftUI

struct iOSView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @State var websocket: Websocket
    var body: some View {
        ZStack {
            if connected == false {
                Image("light-lights-led-812677")
                Rectangle()
                    .fill(.clear)
                    .background(Material.regular)
            }
            VStack {
                if connected == false {
                    HStack {
                        Text("Welcome to PrismDMX Pro")
                            .font(.title)
                            .fontWeight(.black)
                        Image("icon_512x512")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipped()
                    }
                }
                ConnectionView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
            }
        }
        .onAppear {
            connected = false
            error = nil
            workspace = iOSDataModule().load() ?? Workspace(isCompleted: false, settings: Settings(ip: "ws://192.168.178.188", port: "8000/ws/main"), displayMode: 0, notes: [], columnVisible: .all)
        }
        .onDisappear {
            websocket.disconnect(response: true)
            iOSDataModule().save($workspace)
        }
    }
}

struct iOSWorkspaceView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        VStack {
            if $workspace.displayMode.wrappedValue == 0 { //MasterWorkspace
                iOSMasterView(workspace: $workspace, websocket: $websocket, packet: $packet)
            } else if $workspace.displayMode.wrappedValue == 1 { //FixturesWorkspace
                iOSFixturesView(workspace: $workspace, websocket: $websocket, packet: $packet)
            } else if $workspace.displayMode.wrappedValue == 2 { //MixerWorkspace
                iOSMixerView(workspace: $workspace, websocket: $websocket, packet: $packet)
            } else if $workspace.displayMode.wrappedValue == 3 { //PlaybacksWorkspace
                Text("Loading...")
                    .onAppear {
                        workspace.displayMode = 0
                    }
            } else if $workspace.displayMode.wrappedValue == 4 { //StageNotesWorkspace
                NotesView(workspace: $workspace, websocket: $websocket, packet: $packet)
                Text("Loading...")
                    .onAppear {
                        workspace.displayMode = 0
                    }
                
            } else {
                VStack {
                    Text("Error: DisplayMode invalid")
                    Button {
                        workspace.displayMode = 0
                    } label: {
                        Text("Reset")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

struct ConnectionView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    
    @State var isSheetPresented: Bool = false
    var body: some View {
        VStack {
            if connected == true && error == nil {
                iOSSelectProjectView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
                    .onAppear {
                        iOSDataModule().save($workspace)
                    }
            } else {
                Button("Connect") {
                    isSheetPresented.toggle()
                }
                .onAppear {
                    if workspace.isCompleted == true {
                        websocket.connect(ip: $workspace.settings.ip, port: $workspace.settings.port, response: true)
                    }
                }
            }
        }
        .sheet(isPresented: $isSheetPresented, content: {
            ConnectionViewSheet(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket, isSheetPresented: $isSheetPresented)
                .padding(20)
        })
    }
}

struct iOSSelectProjectView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    
    var body: some View {
        VStack {
            if workspace.project == nil {
                if packet.project == nil || packet.project == Project(internalID: "na", name: "na") || packet.project == Project(internalID: "naa", name: "naa") {
                    setProjectView(packet: $packet, workspace: $workspace, websocket: $websocket)
                } else {
                iOSWorkspaceView(workspace: $workspace, websocket: $websocket, packet: $packet) //If a new Project is created
                }
            } else {
                if packet.project == nil || packet.project == Project(internalID: "na", name: "na") {
                    setProjectView(packet: $packet, workspace: $workspace, websocket: $websocket)
                        .onAppear {
                            loadProject()
                        }
                } else {
                    iOSWorkspaceView(workspace: $workspace, websocket: $websocket, packet: $packet) //If an existing project is loaded
                }
            }
        }
    }
    
    func loadProject() {
        websocket.sendNonBindingString(JsonModule().encodeSetProject(setProject(setProject: hiJuDasIstEinNeuesProject(project: workspace.project ?? Project(internalID: "na", name: "na")))) ?? "", response: true)
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
    /*
    private var selectedProject: Project {
        let selectedProjectIndex = sortedProjectIndices[selectedIndex]
        return packet.availableProjects[selectedProjectIndex]
    }*/
    
    var body: some View {
        NavigationStack {
            VStack {
                List(sortedProjectIndices.indices, id: \.self) { index in
                    NavigationLink {
                        Text("Loading...")
                            .onAppear {
                                loadProject(selectedProject: packet.availableProjects[index])
                            }
                    } label: {
                        Text(packet.availableProjects[index].name)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    deleteProject(project: $packet.availableProjects[index].wrappedValue)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .navigationTitle("Select a Project")
            }
            .toolbar(content: {
                Button {
                    createProject()
                } label: {
                    Image(systemName: "plus")
                }

            })
            .sheet(isPresented: $isSheetPresented, content: {
                newProjectSheet(isSheetPresented: $isSheetPresented, websocket: $websocket, workspace: $workspace)
            })
        }
        /*
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
            }
            Spacer()
            HStack {
                Button("Create") { createProject() }
                    .buttonStyle(.bordered)
                Button("Load") {
                    loadProject()
                }
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .sheet(isPresented: $isSheetPresented, content: {
            newProjectSheet(isSheetPresented: $isSheetPresented, websocket: $websocket, workspace: $workspace)
        })*/
    }
    
    func loadProject(selectedProject: Project) {
        workspace.project = selectedProject
        websocket.sendNonBindingString(JsonModule().encodeSetProject(setProject(setProject: hiJuDasIstEinNeuesProject(project: selectedProject))) ?? "", response: true)
        iOSDataModule().save($workspace)
    }
    
    func createProject() {
        isSheetPresented.toggle()
    }
    
    func deleteProject(project: Project) {
        websocket.sendNonBindingString(JsonModule().projectDeletion(PrismDMX_Pro_Mobile.deleteProject(deleteProject: hiJuDasIstEinNeuesProject(project: project))) ?? "", response: true)
    }
}



struct newProjectSheet: View {
    @State var newProject: Project = Project(internalID: "0", name: "New Project")
    
    @Binding var isSheetPresented: Bool
    @Binding var websocket: Websocket
    @Binding var workspace: Workspace
    
    var body: some View {
        VStack {
            Text("New Project")
                .font(.title)
                .fontWeight(.black)
            HStack {
                Text("Name: ")
                TextField("Name", text: $newProject.name)
            }
            Spacer()
            HStack {
                Button("Create") {
                    createProject()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(12)
    }
    
    func createProject() {
        isSheetPresented.toggle()
        websocket.sendNonBindingString(JsonModule().encodeNewProject(PrismDMX_Pro_Mobile.newProject(newProject: hiJuDasIstEinNeuesProject(project: newProject))) ?? "", response: true)
        iOSDataModule().save($workspace)
    }
}

struct ConnectionViewSheet: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    @Binding var isSheetPresented: Bool
    var body: some View {
        if workspace.isCompleted == true {
            if connected == true && error == nil {
                Text("Loading...")
                    .onAppear {
                        isSheetPresented = false
                    }
            } else if connected == true && error != nil {
                iOSErrorView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
            } else if connected == false && error != nil {
                iOSErrorView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
            } else if connected == false && error == nil {
                iOSisConnectingView(workspace: $workspace, websocket: $websocket)
            }
        } else {
            iOSNWSettingsView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
        }
    }
}

struct iOSisConnectingView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    var body: some View {
        Text("Connecting...")
        Button("Cancel") {
            workspace.isCompleted = false
        }
        .onAppear {
            websocket.connect(ip: $workspace.settings.ip, port: $workspace.settings.port, response: true)
        }
    }
}

struct iOSErrorView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    var body: some View {
        VStack {
            Text("An error occured: \(error ?? "unknown error")")
            HStack {
                Button("Settings") {
                    workspace.isCompleted = false
                }
                .buttonStyle(.bordered)
                Button("Retry") {
                    websocket.disconnect(response: true)
                    websocket.connect(ip: $workspace.settings.ip, port: $workspace.settings.port, response: true)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

struct iOSNWSettingsView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    var body: some View {
        VStack {
            Text("Network Settings")
                .font(.title)
                .fontWeight(.black)
            HStack {
                Text("IP: ")
                TextField("IP", text: $workspace.settings.ip)
            }
            HStack {
                Text("Port: ")
                TextField("Port", text: $workspace.settings.port)
            }
            Spacer()
            Button("Connect") {
                workspace.isCompleted = true
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
