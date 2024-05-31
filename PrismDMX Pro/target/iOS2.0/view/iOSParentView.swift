//
//  iOStwo.swift
//  PrismDMX Pro
//
//  Created by Christian on 31.05.24.
//

import Foundation
import SwiftUI

struct iOSMainView: View {
    @State var clientData: ClientData = ClientData(networking: ClientNetworking(nwProtocol: .ws, ip: "127.0.0.1", port: "8000", path: "/ws/main"))
    var body: some View {
        EmptyView()
    }
}
