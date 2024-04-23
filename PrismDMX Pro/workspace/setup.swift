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
    
    var body: some View {
        /*Section("Networking") {
            Button {
                workspace.isCompleted = false
            } label: {
                Text("Server Settings")
            }
        }*/
        NavigationView {
            List {
                NavigationLink {
                    DisableIsCompleted(isCompleted: $workspace.isCompleted)
                } label: {
                    Text("Network Settings")
                }
                NavigationLink {
                } label: {
                    Text("Fixture Configuration")
                }
                .onTapGesture {
                    selectedSetupPage = "fixtureConfiguration"
                }
            }
            currentSetupWindow(selected: $selectedSetupPage)
        }
    }
}

struct currentSetupWindow: View {
    @Binding var selected: String?
    var body: some View {
        if selected == nil {
            Text("Nothing selected")
        } else if selected == "fixtureConfiguration" {
            
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
    @State var localFixtures: [Fixture] = []
    var body: some View {
        Text("Fixture Configuration")
    }
}
