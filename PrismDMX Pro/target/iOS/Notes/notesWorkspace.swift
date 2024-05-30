//
//  notesWorkspace.swift
//  PrismDMX Pro
//
//  Created by Christian on 03.05.24.
//

import Foundation
import SwiftUI


//Discontinued
//Dont use workspace. Notes should be synchronised via whole mixer / every ipad
struct NotesView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        Text("Notes")
    }
}
