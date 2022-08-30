//
//  ConfigView.swift
//  damus
//
//  Created by William Casarin on 2022-06-09.
//

import SwiftUI
import AVFoundation

struct ConfigView: View {
    let state: DamusState
    @Environment(\.dismiss) var dismiss
    @State var show_add_relay: Bool = false
    @State var show_nostr_help: Bool = false
    @State var confirm_logout: Bool = false
    @State var new_relay: String = ""
    @State var highlight: Highlight

    func Relay(_ ev: NostrEvent, relay: String) -> some View {
        return Text(relay)
            .swipeActions {
                if let privkey = state.keypair.privkey {
                    Button {
                        guard let new_ev = remove_relay( ev: ev, privkey: privkey, relay: relay) else {
                            return
                        }
                        
                        state.contacts.event = new_ev
                        state.pool.send(.event(new_ev))
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
    }
    
    var body: some View {
        VStack(alignment: .trailing){
            HStack(){
                Spacer()
                Button(action: { show_add_relay = true }) {
                    Label("", systemImage: "plus")
                        .foregroundColor(.accentColor)

                }
        // Divider()
                Button(action: { show_nostr_help = true }) {
                    Label("", systemImage: "questionmark.circle")
                        .foregroundColor(.accentColor)

                }

            }

        }

            Form {
            Section("Profile Header") {
            // Text("pre HStack")
                HStack(alignment:.center) {
                #if !os(macOS) || targetEnvironment(macCatalyst)
                ProfilePicView(pubkey: state.pubkey, size: PFP_SIZE, highlight: self.highlight, image_cache: state.image_cache, profiles: state.profiles)
                    if let profile_name = Profile.displayName(profile: state.profiles.lookup(id: state.pubkey), pubkey: state.pubkey){

                        Text(profile_name.description )

                    }
                    Spacer()
                #elseif os(macOS)
                    ProfilePicView(pubkey: state.pubkey, size: PFP_SIZE, highlight: self.highlight, profiles: state.profiles)
                    if let profile_name = Profile.displayName(profile: state.profiles.lookup(id: state.pubkey), pubkey: state.pubkey){

                        Text(profile_name.description )

                    }
                    Spacer()

                    #endif
                } // End HStack
            } // End Section Profile Header
                // Text("1st in Form")
                //Text("pre Section")
                Section("Keys"){
                // Text("1st in Section")
                    if let pubkey = state.keypair.pubkey {
                        Section("Public Key") {
                            Text(pubkey)
                                .textSelection(.enabled)
                                .onTapGesture {
                                    #if !os(macOS) || targetEnvironment(macCatalyst)
                                    UIPasteboard.general.string = pubkey
                                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                                    #else
                                    NSPasteboard.general.clearContents()
                                    NSPasteboard.general.setString(pubkey, forType: .string)
                                    #endif
                                }

                        }
                        if let sec = state.keypair.privkey_bech32 {
                                    Section("Private Key") {
                                        Text(sec)
                                            .textSelection(.enabled)
                                            .onTapGesture {
                                                #if !os(macOS) || targetEnvironment(macCatalyst)
                                                UIPasteboard.general.string = sec
                                                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                                                #else
                                                NSPasteboard.general.clearContents()
                                                NSPasteboard.general.setString(sec, forType: .string)
                                                #endif
                                            }
                                    }
                                }

                                //Section("Reset") {
                                    Button("Logout") {
                                        confirm_logout = true
                                    }
                                //}
                    } else {
                        EmptyView()
                    }
                }
                if let ev = state.contacts.event {
                    Section("Relays") {
                        if let relays = decode_json_relays(ev.content) {
                            List(Array(relays.keys.sorted()), id: \.self) { relay in
                                Relay(ev, relay: relay)
                            }
                        }
                        
                    }
                }


            } //End Form

        .navigationTitle("Settings")
        #if !os(macOS) //|| targetEnvironment(macCatalyst)
        .navigationBarTitleDisplayMode(.automatic)
        #else
        .navigationViewStyle(.automatic)
        #endif
        .alert("Logout", isPresented: $confirm_logout) {
            Button("Logout") {
                notify(.logout, ())
            }
            Button("Cancel") {
                confirm_logout = false
            }
        } message: {
            Text("Make sure your nsec account key is saved before you logout or you will lose access to this account")
        }
        .sheet(isPresented: $show_nostr_help) {
            //TODO:
            AddHelpView(show_nostr_help: $show_nostr_help)
        }
        .sheet(isPresented: $show_add_relay) {
            AddRelayView(show_add_relay: $show_add_relay, relay: $new_relay) { m_relay in
                
                guard let relay = m_relay else {
                    return
                }
                
                guard let url = URL(string: relay) else {
                    return
                }
                
                guard let ev = state.contacts.event else {
                    return
                }
                
                guard let privkey = state.keypair.privkey else {
                    return
                }

                let info = RelayInfo.rw
                
                guard (try? state.pool.add_relay(url, info: info)) != nil else {
                    return
                }
                
                state.pool.connect(to: [new_relay])
                
                guard let new_ev = add_relay(ev: ev, privkey: privkey, relay: new_relay, info: info) else {
                    return
                }
                
                state.contacts.event = new_ev
                state.pool.send(.event(new_ev))
            }
        }
        .onReceive(handle_notify(.switched_timeline)) { _ in
            dismiss()
        }

    } //End body
} //End struct ConfigView

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView(state: test_damus_state(),highlight: .none)
    }
}
