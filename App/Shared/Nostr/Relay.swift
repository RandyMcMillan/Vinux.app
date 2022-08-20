//
//  Relay.swift
//  damus
//
//  Created by William Casarin on 2022-04-11.
//

import Foundation

struct RelayInfo: Codable {
    let read: Bool
    let write: Bool

    static let rw = RelayInfo(read: true, write: false)
}

struct RelayDescriptor: Codable {
    let url: URL
    let info: RelayInfo
}

struct Relay: Identifiable {
    let descriptor: RelayDescriptor
    let connection: RelayConnection

    var id: String {
        return get_relay_id(descriptor.url)
    }
    var read: Bool {
        return get_relay_info_read(RelayInfo.rw)
    }

}

enum RelayError: Error {
    case RelayAlreadyExists
    case RelayNotFound
}

func get_relay_id(_ url: URL) -> String {
    print("get_relay_id:",url.absoluteString)
    return url.absoluteString
}
func get_relay_info_read(_ read: RelayInfo) -> Bool {
    print("get_relay_info.read:________________________________________________",RelayInfo.rw.read)
    return RelayInfo.rw.read

}
func get_relay_info_write(_ write: RelayInfo) -> Bool {
    print("get_relay_info.read:________________________________________________",RelayInfo.rw.write)
    return RelayInfo.rw.write

}
