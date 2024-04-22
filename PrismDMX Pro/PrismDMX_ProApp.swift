//
//  PrismDMX_ProApp.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import SwiftUI
import Foundation

@main
struct PrismDMX_ProApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: PrismDMXProDocument()) { file in
            #if os(macOS)
            mainView(document: file.$document)
            #elseif os(iOS)
            iosView()
            #endif
        }
    }
}
