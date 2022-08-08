//
//  ProfileView.swift
//  damus
//
//  Created by William Casarin on 2022-04-23.
//

import SwiftUI

enum ProfileTab: Hashable {
    case posts
    case following
}

enum FollowState {
    case follows
    case following
    case unfollowing
    case unfollows
}

func follow_btn_txt(_ fs: FollowState) -> String {
    switch fs {
    case .follows:
        return "Unfollow"
    case .following:
        return "Following..."
    case .unfollowing:
        return "Unfollowing..."
    case .unfollows:
        return "Follow"
    }
}

func follow_btn_enabled_state(_ fs: FollowState) -> Bool {
    switch fs {
    case .follows:
        return true
    case .following:
        return false
    case .unfollowing:
        return false
    case .unfollows:
       return true
    }
}

struct ProfileNameView: View {
    let pubkey: String
    let profile: Profile?
    
    var body: some View {
        Group {
            if let real_name = profile?.display_name {
                VStack(alignment: .leading) {
                    Text(real_name)
                        .font(.title)
                    ProfileName(pubkey: pubkey, profile: profile, prefix: "@")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            } else {
                ProfileName(pubkey: pubkey, profile: profile)
            }
        }
    }
}

struct ProfileView: View {
    let damus_state: DamusState
    
    @State private var selected_tab: ProfileTab = .posts
    @StateObject var profile: ProfileModel
    @StateObject var followers: FollowersModel
    
    //@EnvironmentObject var profile: ProfileModel
    
    var DMButton: some View {
        let dm_model = damus_state.dms.lookup_or_create(profile.pubkey)
        let dmview = DMChatView(damus_state: damus_state, pubkey: profile.pubkey)
            .environmentObject(dm_model)
        return NavigationLink(destination: dmview) {
            Label("DMButton", systemImage: "text.bubble")
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var TopSection: some View {
        VStack(alignment: .leading) {
            let data = damus_state.profiles.lookup(id: profile.pubkey)
            #if !os(macOS)
            HStack(alignment: .center) {
                ProfilePicView(pubkey: profile.pubkey, size: PFP_SIZE, highlight: .custom(Color.black, 2), image_cache: damus_state.image_cache, profiles: damus_state.profiles)
        
                ProfileNameView(pubkey: profile.pubkey, profile: data)
                Spacer()
                DMButton
                    .padding([.trailing], 20)
                FollowButtonView(target: profile.get_follow_target(), follow_state: damus_state.contacts.follow_state(profile.pubkey))
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()

            }
            #else
            HStack(alignment: .center) {
                ProfilePicView(pubkey: profile.pubkey,
                               size: PFP_SIZE,
                               highlight: .custom(Color.black, 2),
                               profiles: damus_state.profiles
                )
                ProfileNameView(pubkey: profile.pubkey, profile: data)
                Spacer()
                DMButton
                    .padding([.trailing], 20)
                
                FollowButtonView(target: profile.get_follow_target(), follow_state: damus_state.contacts.follow_state(profile.pubkey))
            }
            #endif
            KeyView(pubkey: profile.pubkey)
                .padding(.bottom, 10)
            
            Text(data?.about ?? "")
        
            Divider()
                
            HStack {
                if let contact = profile.contacts {
                    let contacts = contact.referenced_pubkeys.map { $0.ref_id }
                    let following_model = FollowingModel(damus_state: damus_state, contacts: contacts)
                    NavigationLink(destination: FollowingView(damus_state: damus_state, following: following_model, whos: profile.pubkey)) {
                        HStack {
                            Text("\(profile.following)")
                            Text("Following")
                                .foregroundColor(.gray)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                let fview = FollowersView(damus_state: damus_state, whos: profile.pubkey)
                    .environmentObject(followers)
                NavigationLink(destination: fview) {
                    HStack {
                        Text("\(followers.contacts.count)")
                        Text("Followers")
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                TopSection
            
                Divider()
                
                InnerTimelineView(events: $profile.events, damus: damus_state)
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)
        }
        .padding([.leading, .trailing, .top, .bottom], 100) //This make more sense on how it is being layed out now!!
        .frame(maxWidth: .infinity, alignment: .topLeading)
        #if !os(macOS)
        .navigationBarTitle("")
        #endif
        .onAppear() {
            profile.subscribe()
            followers.subscribe()
        }
        .onDisappear {
            profile.unsubscribe()
            followers.unsubscribe()
            // our profilemodel needs a bit more help
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = test_damus_state()
        let followers = FollowersModel(damus_state: ds, target: ds.pubkey)
        let profile_model = ProfileModel(pubkey: ds.pubkey, damus: ds)
        ProfileView(damus_state: ds, profile: profile_model, followers: followers)
    }
}


func test_damus_state() -> DamusState {
    let pubkey = "3efdaebb1d8923ebd99c9e7ace3b4194ab45512e2be79c1b7d68d9243e0d2681"
    #if !os(macOS)

    let damus = DamusState(pool: RelayPool(), keypair: Keypair(pubkey: pubkey, privkey: "privkey"), likes: EventCounter(our_pubkey: pubkey), boosts: EventCounter(our_pubkey: pubkey), contacts: Contacts(), tips: TipCounter(our_pubkey: pubkey), image_cache: ImageCache(), profiles: Profiles(), dms: DirectMessagesModel())
    
    let prof = Profile(name: "damus", display_name: "Damus", about: "iOS app!", picture: "https://damus.io/img/logo.png")
    let tsprof = TimestampedProfile(profile: prof, timestamp: 0)
    damus.profiles.add(id: pubkey, profile: tsprof)

    #else

    let damus = DamusState(pool: RelayPool(), keypair: Keypair(pubkey: pubkey, privkey: "privkey"), likes: EventCounter(our_pubkey: pubkey), boosts: EventCounter(our_pubkey: pubkey), contacts: Contacts(), tips: TipCounter(our_pubkey: pubkey), profiles: Profiles(), dms: DirectMessagesModel())
    
    let prof = Profile(name: "damus", display_name: "Damus", about: "iOS app!", picture: "https://damus.io/img/logo.png")
    let tsprof = TimestampedProfile(profile: prof, timestamp: 0)
    damus.profiles.add(id: pubkey, profile: tsprof)

    #endif

    return damus
}

struct KeyView: View {
    let pubkey: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let col = id_to_color(pubkey)
        
        VStack {
            Text("\(String(pubkey.prefix(32)))")
                .foregroundColor(colorScheme == .light ? .black : col)
                .font(.footnote.monospaced())
            Text("\(String(pubkey.suffix(32)))")
                .font(.footnote.monospaced())
                .foregroundColor(colorScheme == .light ? .black : col)
        }
    }
}

        
