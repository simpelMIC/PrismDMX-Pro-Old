//
//  workspace.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation
import SwiftUI

struct WorkspaceView: View {
    @Binding var workspace: Workspace
    
    @State var selectedSideBarItem: SideBarItem = .config
    @State var sideBarVisibility: NavigationSplitViewVisibility = .doubleColumn
    
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    
    var body: some View {
        NavigationSplitView() {
            List {
                NavigationLink(destination: Setup(workspace: $workspace, websocket: $websocket, packet: $packet), label: { Text("Setup") })
                NavigationLink(destination: ConfigView(packet: $packet), label: { Text("Config")} )
            }
        } detail: {
            ConfigView(packet: $packet)
        }
    }
}
