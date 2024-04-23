//
//  json.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation
import SwiftUI

/*
class fixtureTemplateJson {
    func encode(_ fixtureTemplate: fixtureTemplate) -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(fixtureTemplate)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        return json!
    }
        
    func decode(_ input: String) -> fixtureTemplate {
        let jsonDecoder = JSONDecoder()
        let json = try! jsonDecoder.decode(fixtureTemplate.self, from: input.data(using: .utf8)!)
        return json
    }
}

class fixturesJson {
    func encode(_ fixtures: fixtures) -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(fixtures)
        let json = String(data: jsonData, encoding: String.Encoding.utf8)
        return json!
    }
    
    func decode(_ input: String) -> fixtures {
        let jsonDecoder = JSONDecoder()
        let json = try! jsonDecoder.decode(fixtures.self, from: input.data(using: .utf8)!)
        return json
    }
}
 */

 class JSON<T: Encodable> {
     func encode(_ data: T) -> String {
         let jsonEncoder = JSONEncoder()
         let jsonData = try! jsonEncoder.encode(data)
         let json = String(data: jsonData, encoding: String.Encoding.utf8)
         return json!
     }
 }

struct JSONView: View {
    @Binding var fixtures: [Fixture]
    @State private var jsonData: String?
    var body: some View {
        VStack {
            Button {
                let json = JSON().encode(fixtures)
                jsonData = json
            } label: {
                Text("Encode variables")
            }
            Text(jsonData ?? "No data generated")
        }
        .padding()
    }
}
