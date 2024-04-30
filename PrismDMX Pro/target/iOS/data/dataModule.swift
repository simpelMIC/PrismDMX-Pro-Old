//
//  dataModule.swift
//  PrismDMX Pro
//
//  Created by Christian on 30.04.24.
//

import Foundation
import SwiftUI

class iOSDataModule {
    func save(_ workspace: Binding<Workspace>) {
        UserDefaults.standard.set(iOSJsonModule().encodeEditFixture(workspace.wrappedValue), forKey: "PrismDMXWorkspace")
        print("Saved Workspace")
    }
    
    func load() -> Workspace? {
        let workspace = UserDefaults.standard.string(forKey: "PrismDMXWorkspace")
        if workspace == nil {
            print("No Workspace provided")
            return nil
        } else {
            if let data = workspace!.data(using: .utf8) {
                print("Loaded Workspace")
                return iOSJsonModule().decode(data)
            } else {
                print("Couldn't convert recieved message to data")
                return nil
            }
        }
    }
}

class iOSJsonModule {
    func encodeEditFixture(_ workspace: Workspace) -> String? {
        let encoder = JSONEncoder()
        if let json = try? encoder.encode(workspace) {
            return String(data: json, encoding: .utf8)
        } else {
            print("Error encoding Workspace")
            return nil
        }
    }
    
    func decode(_ data: Data) -> Workspace? {
        let decoder = JSONDecoder()
        if let packetData = try? decoder.decode(Workspace.self, from: data) {
            return packetData
        } else {
            print("Error decoding Workspace")
            return nil
        }
    }
}
