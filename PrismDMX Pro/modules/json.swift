//
//  json.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation
import SwiftUI


func fixtureTemplateJsonEncode(_ fixtureTemplate: fixtureTemplate) -> String {
    let jsonEncoder = JSONEncoder()
    let jsonData = try! jsonEncoder.encode(fixtureTemplate)
    let json = String(data: jsonData, encoding: String.Encoding.utf8)
    
    return json!
}

func fixtureTemplateJsonDecode(_ input: String) -> fixtureTemplate {
    let jsonDecoder = JSONDecoder()
    let json = try! jsonDecoder.decode(fixtureTemplate.self, from: input.data(using: .utf8)!)
    
    return json
}

func fixtureJsonEncode(_ fixtures: fixtures) -> String {
    let jsonEncoder = JSONEncoder()
    let jsonData = try! jsonEncoder.encode(fixtures)
    let json = String(data: jsonData, encoding: String.Encoding.utf8)
    return json!
}

func fixtureJsonDecode(_ input: String) -> fixtures {
    let jsonDecoder = JSONDecoder()
    let json = try! jsonDecoder.decode(fixtures.self, from: input.data(using: .utf8)!)
    return json
}
