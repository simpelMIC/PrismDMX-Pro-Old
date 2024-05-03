//
//  notesWorkspace.swift
//  PrismDMX Pro
//
//  Created by Christian on 03.05.24.
//

import Foundation
import SwiftUI

struct NotesView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        Text("Notes")
    }
}
