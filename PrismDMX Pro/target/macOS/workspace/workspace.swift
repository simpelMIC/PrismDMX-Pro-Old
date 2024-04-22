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
    
    var body: some View {
        #if os(macOS)
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
                Setup(wsSettings: $workspace.settings.wsSettings)
            case .config:
                EmptyView()
            case .playbacks:
                EmptyView()
            }
        }
        #else
        EmptyView()
        #endif
    }
}

#Preview {
    WorkspaceView(workspace: .constant(Workspace(isCompleted: true, settings: Settings(wsSettings: WsSettings(ip: "", port: "")))))
}
