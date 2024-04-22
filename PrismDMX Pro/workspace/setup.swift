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
    
    var body: some View {
        Section("Networking") {
            Button {
                workspace.isCompleted = false
            } label: {
                Text("Server Settings")
            }

        }
    }
}
