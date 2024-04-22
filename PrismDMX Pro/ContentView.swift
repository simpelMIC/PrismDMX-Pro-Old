//
//  ContentView.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: PrismDMX_ProDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(PrismDMX_ProDocument()))
}
