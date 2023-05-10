//
//  WalletModel.swift
//  damus
//
//  Created by William Casarin on 2023-05-09.
//

import Foundation

enum WalletConnectState {
    case new(WalletConnectURL)
    case existing(WalletConnectURL)
    case none
}

class WalletModel: ObservableObject {
    let settings: UserSettingsStore?
    private(set) var previous_state: WalletConnectState
    @Published private(set) var connect_state: WalletConnectState
    
    init() {
        self.connect_state = .none
        self.previous_state = .none
        self.settings = nil
    }
    
    init(settings: UserSettingsStore) {
        self.settings = settings
        if let str = settings.nostr_wallet_connect,
           let nwc = WalletConnectURL(str: str) {
            self.previous_state = .existing(nwc)
            self.connect_state = .existing(nwc)
        } else {
            self.previous_state = .none
            self.connect_state = .none
        }
    }
    
    func cancel() {
        self.connect_state = previous_state
        self.objectWillChange.send()
    }
    
    func disconnect() {
        self.settings?.nostr_wallet_connect = nil
        self.connect_state = .none
        self.previous_state = .none
    }
    
    func new(_ nwc: WalletConnectURL) {
        self.connect_state = .new(nwc)
    }
    
    func connect(_ nwc: WalletConnectURL) {
        self.settings?.nostr_wallet_connect = nwc.to_url().absoluteString
        self.connect_state = .existing(nwc)
        self.previous_state = .existing(nwc)
    }
}
