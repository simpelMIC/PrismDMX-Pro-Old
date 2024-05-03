//
//  MixerWorkspace.swift
//  PrismDMX Pro
//
//  Created by Christian on 02.05.24.
//

import Foundation
import SwiftUI

struct iOSMixerView: View {
    @Binding var workspace: Workspace
    @Binding var websocket: Websocket
    @Binding var packet: Packet
    var body: some View {
        Text("MixerView")
    }
}
