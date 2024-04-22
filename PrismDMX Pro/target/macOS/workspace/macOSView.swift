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
    case channels
    case playbacks
}

struct mainView: View {
    @Binding var document: PrismDMXProDocument
    
    @State var selectedSideBarItem: SideBarItem = .channels
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
                EmptyView()
            case .channels:
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
    mainView(document: .constant(PrismDMXProDocument(workspace: Workspace(settings: Settings(wsSettings: WsSettings(ip: "", port: ""))))))
}
