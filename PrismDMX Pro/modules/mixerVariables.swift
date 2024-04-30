//
//  mixerVariables.swift
//  PrismDMX Pro
//
//  Created by Christian on 29.04.24.
//

import Foundation

struct Mixer: Equatable, Codable {
    var pages: [MixerPage]
    var color: String
    var isMixerAvailable: String //Bool
    var mixerType: String //Divides between 5/10/15 .. mixers
}

struct MixerPage: Equatable, Codable {
    var num: String
    var faders: [MixerFader]
    var buttons: [MixerButton]
}

struct MixerFader: Equatable, Codable {
    var name: String
    var color: String //HEX f.e. 0xffffff
    var isTouched: String //Bool
    var value: String //Int
    var assignedType: String
    var assignedID: String
}

struct MixerButton: Equatable, Codable {
    var name: String
    var color: String
    var isPressed: String //Bool
    var assignedType: String
    var assignedID: String
}
