//
//  ContentView.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: PrismDMXProDocument
    var body: some View {
        EmptyView()
    }
}

#Preview {
    ContentView(document: .constant(PrismDMXProDocument(workspace: Workspace(text: ""))))
}
