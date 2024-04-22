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

class Websocket: WebSocketConnectionDelegate {
    var socket: NWWebSocket?
    
    func connect(ip: String, port: String, response: Bool) {
        if let socketURL = URL(string: "\(ip):\(port)") {
            self.socket = NWWebSocket(url: socketURL)
            self.socket?.delegate = self
            self.socket?.connect()
            if response == true {
                print("Websocket connected to: \(ip):\(port)")
            }
        }
    }
    
    func disconnect(response: Bool) {
        socket?.disconnect()
        if response == true {
            print("Websocket disconnect")
        }
    }
    
    func sendData(_ data: [UInt8], response: Bool) {
        let messageData = Data(data)
        self.socket?.send(data: messageData)
        if response == true {
            print("Sent data: \(data)")
        }
    }
    
    func sendString(_ string: String, response: Bool) {
        socket?.send(string: string)
        if response == true {
            print("Sent message: \(string)")
        }
    }
    
    func webSocketDidConnect(connection: WebSocketConnection) {
        print("WebSocket connected")
    }

    func webSocketDidDisconnect(connection: WebSocketConnection, closeCode: NWProtocolWebSocket.CloseCode, reason: Data?) {
        print("WebSocket disconnected with code: \(closeCode)")
    }

    func webSocketViabilityDidChange(connection: WebSocketConnection, isViable: Bool) {
        print("WebSocket viability changed to: \(isViable)")
    }

    func webSocketDidAttemptBetterPathMigration(result: Result<WebSocketConnection, NWError>) {
        print("WebSocket attempted better path migration")
    }

    func webSocketDidReceiveError(connection: WebSocketConnection, error: NWError) {
        print("WebSocket received error: \(error)")
        //-65554: NoSuchRecord :: This error occurs when a host is not reachable
        //POSIXErrorCode(rawValue: 50): Network is down :: This error occurs when the network down is.
    }

    func webSocketDidReceivePong(connection: WebSocketConnection) {
        print("WebSocket received Pong")
    }

    func webSocketDidReceiveMessage(connection: WebSocketConnection, string: String) {
        print("WebSocket received message as string: \(string)")
    }

    func webSocketDidReceiveMessage(connection: WebSocketConnection, data: Data) {
        print("WebSocket received message as data: \(data)")
    }
}
