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
        NavigationSplitView(columnVisibility: $sideBarVisibility) {
            List(SideBarItem.allCases, selection: $selectedSideBarItem) { item in
                NavigationLink(
                    item.rawValue.localizedCapitalized,
                    value: item
                )
                .frame(minWidth: 120, idealWidth: 150, maxWidth: 200, alignment: .topLeading)
            }
        } detail: {
            switch selectedSideBarItem {
            case .setup:
                Setup(workspace: $workspace, websocket: $websocket, packet: $packet)
            case .config:
                ZStack {
                    /*LinearGradient(gradient: Gradient(colors: [Color(hex: /*Int(packet.mixer.color) ?? */0xffffff), Color(NSColor.windowBackgroundColor)]), startPoint: .leading, endPoint: .trailing)
                    Rectangle()
                        .fill(.clear)
                        .background(Material.regular)*/
                    ConfigView(mixer: $packet.mixer)
                }
            case .playbacks:
                EmptyView()
            }
        }
    }
}
