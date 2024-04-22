//
//  PrismDMX_ProApp.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import SwiftUI

@main
struct PrismDMX_ProApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: PrismDMXProDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
