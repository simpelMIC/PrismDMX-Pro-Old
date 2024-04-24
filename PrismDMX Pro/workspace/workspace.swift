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
    @Binding var packet: packet
    
    var body: some View {
        NavigationSplitView(columnVisibility: $sideBarVisibility) {
            List(SideBarItem.allCases, selection: $selectedSideBarItem) { item in
                NavigationLink(
                    item.rawValue.localizedCapitalized,
                    value: item
                )
            }
        } detail: {
            switch selectedSideBarItem {
            case .setup:
                Setup(workspace: $workspace, websocket: $websocket, packet: $packet)
            case .config:
                EmptyView()
            case .playbacks:
                EmptyView()
            }
        }
    }
}
