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
    
    func connect(ip: String, port: String) {
        if let socketURL = URL(string: "\(ip):\(port)") {
            self.socket
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

class Websocketssss: WebSocketConnectionDelegate {
    @Binding var isConnected: Bool
    @Binding var wsError: Bool
    
    var ip: String = ""
    var port: String = ""
    var socket: NWWebSocket?
    
    init(isConnected: Binding<Bool>, wsError: Binding<Bool>) {
        self._isConnected = isConnected
        self._wsError = wsError
    }
    
    func connect() {
        if let socketURL = URL(string: "https://echo.websocket.org") {
            self.socket = NWWebSocket(url: socketURL)
            self.socket?.delegate = self
            self.socket?.connect()
        } else {
            print("Invalid URL")
        }
    }
    
    func disconnect() {
        socket?.disconnect()
        isConnected = false
        wsError = false
    }
    
    func sendData() {
        let data: [UInt8] = [123, 234]
        let messageData = Data(data)
        self.socket?.send(data: messageData)
        // Use the WebSocket…
    }
    
    func sendString() {
        let message = "Hello, world!"
        socket?.send(string: message)
        print("Sent message: Hello, world!")
    }

    func webSocketDidConnect(connection: WebSocketConnection) {
        print("WebSocket connected")
        isConnected = true
    }

    func webSocketDidDisconnect(connection: WebSocketConnection, closeCode: NWProtocolWebSocket.CloseCode, reason: Data?) {
        print("WebSocket disconnected with code: \(closeCode)")
        isConnected = false
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
        wsError = true
        isConnected = false
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
