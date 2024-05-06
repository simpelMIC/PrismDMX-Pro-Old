//
//  PlaybacksWorkspace.swift
//  PrismDMX Pro
//
//  Created by Christian on 06.05.24.
//

import Foundation
import SwiftUI

struct PlaybacksWorkspace: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        Text("Playbacks")
    }
}
