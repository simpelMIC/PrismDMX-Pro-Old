//
//  ws.swift
//  PrismDMX Pro
//
//  Created by Christian on 22.04.24.
//

import Foundation
import SwiftUI
import Network
import NWWebSocket

//Responses are console logs
class Websocket: WebSocketConnectionDelegate {
    var socket: NWWebSocket?
    
    @Binding var connected: Bool
    @Binding var error: String?
    
    @Binding var workspace: Workspace
    @Binding var packet: Packet
    
    init(connected: Binding<Bool>, error: Binding<String?>, workspace: Binding<Workspace>, packet: Binding<Packet>) {
        self._connected = connected
        self._error = error
        self._workspace = workspace
        self._packet = packet
    }
    
    //Connection
    
    func connect(ip: Binding<String>, port: Binding<String>, response: Bool) {
        // Check if the IP is a valid URL
        guard let url = URL(string: ip.wrappedValue), url.scheme != nil else {
            // Print an error message or handle the invalid URL case as needed
            error = "Invalid URL: \(ip.wrappedValue)"
            return
        }
        
        // Connect only if the port is empty
        if port.wrappedValue.isEmpty {
            if response {
                print("Connecting to \(ip.wrappedValue)")
            }
            connectToSocket(url: url, response: response)
        } else {
            // If the port is provided, proceed with the connection
            let urlString = "\(ip.wrappedValue):\(port.wrappedValue)"
            if let socketURL = URL(string: urlString) {
                if response {
                    print("Connecting to \(urlString)...")
                }
                connectToSocket(url: socketURL, response: response)
            } else {
                error = "Invalid URL: \(urlString)"
            }
        }
    }

    func connectToSocket(url: URL, response: Bool) {
        self.socket = NWWebSocket(url: url)
        self.socket?.delegate = self
        self.socket?.connect()
        if response {
            print("Websocket connected to: \(url)")
        }
    }
    
    func disconnect(response: Bool) {
        socket?.disconnect()
        connected = false
        error = nil
        if response == true {
            print("Websocket disconnect")
        }
    }
    
    //Data
    
    func sendData(_ data: Binding<[UInt8]>, response: Bool) {
        let messageData = Data(data.wrappedValue)
        self.socket?.send(data: messageData)
        if response == true {
            print("Sent data: \(data)")
        }
    }
    
    func sendString(_ string: Binding<String>, response: Bool) {
        socket?.send(string: string.wrappedValue)
        if response == true {
            print("Sent message: \(string)")
        }
    }
    
    func sendNonBindingString(_ string: String, response: Bool) {
        socket?.send(string: string)
        if response == true {
            print("Sent message: \(string)")
        }
    }
    
    //WS Events
    
    func webSocketDidConnect(connection: WebSocketConnection) {
        print("WebSocket connected")
        connected = true
        error = nil
    }

    func webSocketDidDisconnect(connection: WebSocketConnection, closeCode: NWProtocolWebSocket.CloseCode, reason: Data?) {
        print("WebSocket disconnected with code: \(closeCode)")
        connected = false
        error = "Connection lost"
    }

    func webSocketViabilityDidChange(connection: WebSocketConnection, isViable: Bool) {
        print("WebSocket viability changed to: \(isViable)")
    }

    func webSocketDidAttemptBetterPathMigration(result: Result<WebSocketConnection, NWError>) {
        print("WebSocket attempted better path migration")
    }

    func webSocketDidReceiveError(connection: WebSocketConnection, error: NWError) {
        print("WebSocket received error: \(error)")
        self.error = error.localizedDescription
    }

    func webSocketDidReceivePong(connection: WebSocketConnection) {
        print("WebSocket received Pong")
    }

    func webSocketDidReceiveMessage(connection: WebSocketConnection, string: String) {
        print("WebSocket received message as string: \(string)")
        //On Recieve change data
        if let data = string.data(using: .utf8) {
            packet = JsonModule().decode(data) ?? Packet(project: nil, availableProjects: [Project(internalID: "0", name: "error")], fixtures: [], fixtureTemplates: [], mixer: Mixer(pages: [], color: "0xffffff", isMixerAvailable: "false", mixerType: "0"), fixtureGroups: [], setup: "false", channels: "false", selectedFixtureIDs: [], selectedFixtureGroupIDs: [])
        } else {
            print("Couldn't convert recieved message to data")
        }
    }

    func webSocketDidReceiveMessage(connection: WebSocketConnection, data: Data) {
        print("WebSocket received message as data: \(data)")
    }
}
