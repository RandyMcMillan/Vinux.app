//
//  TinyProfileView.swift
//  damus
//
//  Created by William Casarin on 2022-04-23.
//

import SwiftUI

enum TinyProfileTab: Hashable {
    case posts
    case following
}

enum TinyFollowState {
    case follows
    case following
    case unfollowing
    case unfollows
}

func follow_btn_txt(_ fs: TinyFollowState) -> String {
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

func follow_btn_enabled_state(_ fs: TinyFollowState) -> Bool {
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

struct TinyProfileNameView: View {

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

struct TinyProfileView: View {
    let damus_state: DamusState
    
    @State private var selected_tab: ProfileTab = .posts // Will this conform to List protocol?
    @StateObject var profile: ProfileModel
    // @StateObject var followers: FollowersModel
    
    //@EnvironmentObject var profile: ProfileModel
    
    // var DMButton: some View {
    //     let dm_model = damus_state.dms.lookup_or_create(profile.pubkey)
    //     let dmview = DMChatView(damus_state: damus_state, pubkey: profile.pubkey)
    //         .environmentObject(dm_model)
    //     return NavigationLink(destination: dmview) {
    //         Label("DMButton", systemImage: "text.bubble")
    //     }
    //     .buttonStyle(PlainButtonStyle())
    // }
    
    var TopSection: some View {
        VStack(alignment: .leading) {
            let data = damus_state.profiles.lookup(id: profile.pubkey)
            #if !os(macOS)
            HStack(alignment: .center) {
                ProfilePicView(pubkey: profile.pubkey, size: PFP_SIZE, highlight: .custom(Color.black, 2), image_cache: damus_state.image_cache, profiles: damus_state.profiles)
        
                ProfileNameView(pubkey: profile.pubkey, profile: data)
                Spacer()
                // DMButton
                    // .padding([.trailing], 20)
                // FollowButtonView(target: profile.get_follow_target(), follow_state:
                // damus_state.contacts.follow_state(profile.pubkey))
                Spacer()
                //Spacer()
                //Spacer()
                //Spacer()
                //Spacer()

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
                // DMButton
                   // .padding([.trailing], 20)
                
               //  FollowButtonView(target: profile.get_follow_target(), follow_state: damus_state.contacts.follow_state(profile.pubkey))
            }
            #endif
            // KeyView(pubkey: profile.pubkey)
               // .padding(.bottom, 10)
            
            // Text(data?.about ?? "")
        
            // Divider()
                
            // HStack {
            //     if let contact = profile.contacts {
            //         let contacts = contact.referenced_pubkeys.map { $0.ref_id }
            //         let following_model = FollowingModel(damus_state: damus_state, contacts: contacts)
            //         NavigationLink(destination: FollowingView(damus_state: damus_state, following: following_model, whos: profile.pubkey)) {
            //             HStack {
            //                 Text("\(profile.following)")
            //                 Text("Following")
            //                     .foregroundColor(.gray)
            //             }
            //         }
            //         .buttonStyle(PlainButtonStyle())
            //     }
            //     let fview = FollowersView(damus_state: damus_state, whos: profile.pubkey)
            //         .environmentObject(followers)
            //     NavigationLink(destination: fview) {
            //         HStack {
            //             Text("\(followers.contacts.count)")
            //             Text("Followers")
            //                 .foregroundColor(.gray)
            //         }
            //     }
            //     .buttonStyle(PlainButtonStyle())
            }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView {
                // Divider()
                Text("before TopSection")
                TopSection
                Text("after TopSection")

                // InnerTimelineView(events: $profile.events, damus: damus_state)

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
            // followers.subscribe()
        }
        .onDisappear {
            profile.unsubscribe()
            // followers.unsubscribe()
            // our profilemodel needs a bit more help
        }
    }
}

struct TinyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let ds = test_damus_state()
        let profile_model = ProfileModel(pubkey: ds.pubkey, damus: ds)
        TinyProfileView(damus_state: ds, profile: profile_model)
    }
}

//$ 0| sha -a 256 = e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
func tiny_test_damus_state() -> DamusState {
    let pubkey = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    #if !os(macOS)

    let Vinux = DamusState(pool: RelayPool(), keypair: Keypair(pubkey: pubkey, privkey: "privkey"), likes: EventCounter(our_pubkey: pubkey), boosts: EventCounter(our_pubkey: pubkey), contacts: Contacts(), tips: TipCounter(our_pubkey: pubkey), image_cache: ImageCache(), profiles: Profiles(), dms: DirectMessagesModel())
    
    let prof = Profile(name: "vinux", display_name: "Vinux", about: "Vinux.app!", picture: "https://vinux.app/App/Shared/Support/Assets.xcassets/AppIcon.appiconset/icon_512x512.png")
    let tsprof = TimestampedProfile(profile: prof, timestamp: 0)
    Vinux.profiles.add(id: pubkey, profile: tsprof)

    #else

    let Vinux = DamusState(pool: RelayPool(), keypair: Keypair(pubkey: pubkey, privkey: "privkey"), likes: EventCounter(our_pubkey: pubkey), boosts: EventCounter(our_pubkey: pubkey), contacts: Contacts(), tips: TipCounter(our_pubkey: pubkey), profiles: Profiles(), dms: DirectMessagesModel())
    
    let prof = Profile(name: "damus", display_name: "Damus", about: "iOS app!", picture: "https://damus.io/img/logo.png")
    let tsprof = TimestampedProfile(profile: prof, timestamp: 0)
    Vinux.profiles.add(id: pubkey, profile: tsprof)

    #endif

    return Vinux
}

struct TinyKeyView: View {
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

        
