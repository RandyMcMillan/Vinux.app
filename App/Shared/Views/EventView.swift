//
//  EventView.swift
//  damus
//
//  Created by William Casarin on 2022-04-11.
//

import Foundation
import SwiftUI

enum Highlight {
    case none
    case main
    case reply
    case custom(Color, Float)

    var is_main: Bool {
        if case .main = self {
            return true
        }
        return false
    }

    var is_none: Bool {
        if case .none = self {
            return true
        }
        return false
    }

    var is_replied_to: Bool {
        switch self {
        case .reply: return true
        default: return false
        }
    }
}

struct EventView: View {
    let event: NostrEvent
    let highlight: Highlight
    let has_action_bar: Bool
    let damus: DamusState
    let pubkey: String

    @EnvironmentObject var action_bar: ActionBarModel

    init(event: NostrEvent, highlight: Highlight, has_action_bar: Bool, damus: DamusState) {
        self.event = event
        self.highlight = highlight
        self.has_action_bar = has_action_bar
        self.damus = damus
        self.pubkey = event.pubkey
    }

    init(damus: DamusState, event: NostrEvent) {
        self.event = event
        self.highlight = .none
        self.has_action_bar = false
        self.damus = damus
        self.pubkey = event.pubkey
    }

    init(damus: DamusState, event: NostrEvent, pubkey: String) {
        self.event = event
        self.highlight = .none
        self.has_action_bar = false
        self.damus = damus
        self.pubkey = pubkey
    }

    var body: some View {
        return Group {
            if event.known_kind == .boost, let inner_ev = event.inner_event {
                VStack(alignment: .leading) {
                    let prof_model = ProfileModel(pubkey: event.pubkey, damus: damus)
                    let follow_model = FollowersModel(damus_state: damus, target: event.pubkey)
                    let booster_profile = ProfileView(damus_state: damus, profile: prof_model, followers: follow_model)
                    
                    NavigationLink(destination: booster_profile) {
                        HStack {
                            Label("HStack Label", systemImage: "arrow.2.squarepath")
                                .foregroundColor(Color.gray)
                            ProfileName(pubkey: event.pubkey, profile: damus.profiles.lookup(id: event.pubkey))
                                .foregroundColor(Color.gray)
                            Text(" Boosted")
                                .foregroundColor(Color.gray)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    TextEvent(inner_ev, pubkey: inner_ev.pubkey)
                }
            } else {
                TextEvent(event, pubkey: pubkey)
            }
        }
    }

    func TextEvent(_ event: NostrEvent, pubkey: String) -> some View {
        let content = event.get_content(damus.keypair.privkey)
        return HStack(alignment: .top) {
            let profile = damus.profiles.lookup(id: pubkey)
            VStack {
                let pmodel = ProfileModel(pubkey: pubkey, damus: damus)
                let pv = ProfileView(damus_state: damus, profile: pmodel, followers: FollowersModel(damus_state: damus, target: pubkey))
                #if !os(macOS)
                NavigationLink(destination: pv) {
                    ProfilePicView(pubkey: pubkey, size: PFP_SIZE, highlight: highlight, image_cache: damus.image_cache, profiles: damus.profiles)
                }
                #else
                NavigationLink(destination: pv) {
                    ProfilePicView(pubkey: pubkey, size: PFP_SIZE, highlight: highlight, profiles: damus.profiles)
                }
                #endif
                Spacer()
            }

            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    ProfileName(pubkey: pubkey, profile: profile)
                    Text("\(format_relative_time(event.created_at))")
                        .foregroundColor(.gray)
                }

                if event.is_reply(damus.keypair.privkey) {
                    Text("\(reply_desc(profiles: damus.profiles, event: event))")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                NoteContentView(privkey: damus.keypair.privkey, event: event, profiles: damus.profiles, content: content)
                    #if !os(macOS)
                    .frame(
                        minWidth:    UIScreen.main.bounds.width*0.00,
                        idealWidth:  UIScreen.main.bounds.width*0.10,
                        maxWidth:    UIScreen.main.bounds.width*0.50,
                        minHeight:   UIScreen.main.bounds.width*0.10,
                        idealHeight: UIScreen.main.bounds.width*0.20,
                        maxHeight:   UIScreen.main.bounds.width*0.50,
                        alignment:   .leading
                    )
                    #else
                    .frame(
                        // minWidth:    UIScreen.main.bounds.width*0.00,
                        // idealWidth:  UIScreen.main.bounds.width*0.10,
                        // maxWidth:    UIScreen.main.bounds.width*0.50,
                        // minHeight:   UIScreen.main.bounds.width*0.10,
                        // idealHeight: UIScreen.main.bounds.width*0.20,
                        // maxHeight:   UIScreen.main.bounds.width*0.50,
                        alignment:   .leading
                    )
                    #endif
                    //.frame(maxWidth: UIScreen.main.bounds.width*0.80, alignment: .topLeading)
                    // .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)

                if has_action_bar {
                    let bar = make_actionbar_model(ev: event, damus: damus)
                    EventActionBar(damus_state: damus, event: event, bar: bar)
                }

                Divider()
                    .padding([.top], 4)
            }
            .padding([.leading], 2)
        }
        .contentShape(Rectangle())
        .id(event.id)
        .frame(minHeight: PFP_SIZE)
        .padding([.bottom], 4)
        .event_context_menu(event, privkey: damus.keypair.privkey)
    }
}

extension View {

    func event_context_menu(_ event: NostrEvent, privkey: String?) -> some View {
        return self.contextMenu {
            
// #if os(macOS)
//     NSPasteboard.general.declareTypes([.string], owner: nil)
// #endi
        
// #if !os(macOS)
// UIPasteboard.general.string = text
// #else
// NSPasteboard.general.declareTypes([.string], owner: nil)
// NSPasteboard.general.clearContents()
// NSPasteboard.general.setString(text, forType: .string)
// #endif

            Button {
                #if !os(macOS)
                UIPasteboard.general.string = event.get_content(privkey)
                #else
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(event.get_content(privkey), forType: .string)
                #endif
            } label: {
                Label("Copy Text", systemImage: "doc.on.doc")
            }

            Button {
                #if !os(macOS)
                UIPasteboard.general.string = "@" + event.pubkey
                #else
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString("@" + event.pubkey, forType: .string)
                #endif
            } label: {
                Label("Copy User ID", systemImage: "tag")
            }

            Button {
                #if !os(macOS)
                UIPasteboard.general.string = "&" + event.pubkey
                #else
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString("&" + event.pubkey, forType: .string)
                #endif
            } label: {
                Label("Copy Note ID", systemImage: "tag")
            }

            Button {
                #if !os(macOS)
                UIPasteboard.general.string = event_to_json(ev: event)
                #else
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(event_to_json(ev: event), forType: .string)
                #endif
            } label: {
                Label("Copy Note", systemImage: "note")
            }

            Button {
                NotificationCenter.default.post(name: .broadcast_event, object: event)
            } label: {
                Label("Broadcast", systemImage: "globe")
            }
        }

    }
}

func format_relative_time(_ created_at: Int64) -> String
{
    return time_ago_since(Date(timeIntervalSince1970: Double(created_at)))
}

func reply_desc(profiles: Profiles, event: NostrEvent) -> String {
    let desc = make_reply_description(event.tags)
    let pubkeys = desc.pubkeys
    let n = desc.others

    if desc.pubkeys.count == 0 {
        return "Reply to self"
    }

    let names: [String] = pubkeys.map {
        let prof = profiles.lookup(id: $0)
        return Profile.displayName(profile: prof, pubkey: $0)
    }

    if names.count == 2 {
        if n > 2 {
            let and_other = reply_others_desc(n: n, n_pubkeys: pubkeys.count)
            return "Replying to \(names[0]), \(names[1])\(and_other)"
        }
        return "Replying to \(names[0]) & \(names[1])"
    }

    let and_other = reply_others_desc(n: n, n_pubkeys: pubkeys.count)
    return "Replying to \(names[0])\(and_other)"
}

func reply_others_desc(n: Int, n_pubkeys: Int) -> String {
    let other = n - n_pubkeys
    let plural = other == 1 ? "" : "s"
    return n > 1 ? " & \(other) other\(plural)" : ""
}



func make_actionbar_model(ev: NostrEvent, damus: DamusState) -> ActionBarModel {
    let likes = damus.likes.counts[ev.id]
    let boosts = damus.boosts.counts[ev.id]
    let tips = damus.tips.tips[ev.id]
    let our_like = damus.likes.our_events[ev.id]
    let our_boost = damus.boosts.our_events[ev.id]
    let our_tip = damus.tips.our_tips[ev.id]

    return ActionBarModel(likes: likes ?? 0,
                          boosts: boosts ?? 0,
                          tips: tips ?? 0,
                          our_like: our_like,
                          our_boost: our_boost,
                          our_tip: our_tip
    )
}


