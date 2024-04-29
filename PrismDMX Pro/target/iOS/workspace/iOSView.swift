//
//  iOSView.swift
//  PrismDMX Pro
//
//  Created by Christian on 29.04.24.
//

import Foundation
import SwiftUI

struct iOSView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    var body: some View {
        ConnectionView(workspace: $workspace, packet: $packet, connected: $connected, error: $error, websocket: $websocket)
    }
}

struct ConnectionView: View {
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    @Binding var connected: Bool
    @Binding var error: String?
    @Binding var websocket: Websocket
    var body: some View {
        if connected == true && error == nil {
            //workspace
        } else if connected == true && error != nil {
            //kick from workspace: error
        } else if connected == false && error != nil {
            //error
        } else if connected == false && error == nil {
            //still connecting
        }
    }
}
