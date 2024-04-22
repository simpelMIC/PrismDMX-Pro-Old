//
//  macOSView.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import SwiftUI

struct mainView: View {
    @Binding var document: PrismDMXProDocument
    var json = fixtureTemplateJson()
    
    var body: some View {
        Text("macOS")
    }
}

/*
#Preview {
    mainView(document: .constant(PrismDMXProDocument(workspace: Workspace(text: ""))))
}
*/
