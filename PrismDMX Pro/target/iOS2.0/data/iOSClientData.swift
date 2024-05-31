//
//  iOSSavedData.swift
//  PrismDMX Pro
//
//  Created by Christian on 31.05.24.
//

import Foundation

///Client Data
///Modules:
/// - ClientData
///     - Main Data which is saved
/// - ClientNetworking
///     - Saves all networking stuff

//Defines networking-protocols
enum NWProtocol: Codable {
    case https
    case http
    case ws
}

//Main Module for saved data
struct ClientData: Codable {
    var networking: ClientNetworking
}

//Saves networking data
struct ClientNetworking: Codable {
    var nwProtocol: NWProtocol
    var ip: String
    var port: String
    var path: String
}
