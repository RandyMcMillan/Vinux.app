//
//  ProfilePicView.swift
//  damus
//
//  Created by William Casarin on 2022-04-16.
//

import SwiftUI

let PFP_SIZE: CGFloat = 52.0

func id_to_color(_ id: String) -> Color {
    return hex_to_rgb(id)
}

func highlight_color(_ h: Highlight) -> Color {
    switch h {
    case .main: return Color.red
    case .reply: return Color.black
    case .none: return Color.black
    case .custom(let c, _): return c
    }
}

func pfp_line_width(_ h: Highlight) -> CGFloat {
    switch h {
    case .reply: return 0
    case .none: return 0
    case .main: return 3
    case .custom(_, let lw): return CGFloat(lw)
    }
}

struct ProfilePicView: View {
    let pubkey: String
    let size: CGFloat
    let highlight: Highlight
    #if !os(macOS)
    let image_cache: ImageCache
    #else
    // let image_cache: NSImageCache
    #endif
    let profiles: Profiles
    
    @State var picture: String? = nil
    @State var img: Image? = nil
    
    var PlaceholderColor: Color {
        return id_to_color(pubkey)
    }
    
    var Placeholder: some View {
        PlaceholderColor
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(highlight_color(highlight), lineWidth: pfp_line_width(highlight)))
            .padding(2)
    }
    
    var MainContent: some View {
        Group {
            if let img = self.img {
                img
                    .resizable()
                    .frame(width: size, height: size)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(highlight_color(highlight), lineWidth: pfp_line_width(highlight)))
                    .padding(2)
            } else {
                Placeholder
            }
        }
    }
    
    var body: some View {
        MainContent
            .task {
                let pic = picture ?? profiles.lookup(id: pubkey)?.picture ?? robohash(pubkey)
                guard let url = URL(string: pic) else {
                    return
                }
                #if !os(macOS)
                let pfp_key = pfp_cache_key(url: url)
                let ui_img = await image_cache.lookup_or_load_image(key: pfp_key, url: url)
                
                if let ui_img = ui_img {
                    self.img = Image(uiImage: ui_img)
                    return
                }
                #else
                #endif
            }
            .onReceive(handle_notify(.profile_updated)) { notif in
                let updated = notif.object as! ProfileUpdate

                guard updated.pubkey == self.pubkey else {
                    return
                }
                
                if let pic = updated.profile.picture {
                    if let url = URL(string: pic) {
                        #if !os(macOS)
                        let pfp_key = pfp_cache_key(url: url)
                        if let ui_img = image_cache.lookup_sync(key: pfp_key) {
                            self.img = Image(uiImage: ui_img)
                        }
                        #else
                        #endif
                    }
                }
            }
    }
}

func make_preview_profiles(_ pubkey: String) -> Profiles {
    let profiles = Profiles()
    let picture = "http://cdn.jb55.com/img/red-me.jpg"
    let profile = Profile(name: "jb55", display_name: "William Casarin", about: "It's me", picture: picture)
    let ts_profile = TimestampedProfile(profile: profile, timestamp: 0)
    profiles.add(id: pubkey, profile: ts_profile)
    return profiles
}

struct ProfilePicView_Previews: PreviewProvider {
    static let pubkey = "ca48854ac6555fed8e439ebb4fa2d928410e0eef13fa41164ec45aaaa132d846"
#if !os(macOS)
    static var previews: some View {
        ProfilePicView(
            pubkey: pubkey,
            size: 100,
            highlight: .none,
            image_cache: ImageCache(),
            profiles: make_preview_profiles(pubkey))
    }
#else
    static var previews: some View {
        ProfilePicView(
            pubkey: pubkey,
            size: 100,
            highlight: .none,
            profiles: make_preview_profiles(pubkey))
    }
#endif
}

func hex_to_rgb(_ hex: String) -> Color {
    guard hex.count >= 6 else {
        return Color.black
    }
    
    let arr = Array(hex.utf8)
    var rgb: [UInt8] = []
    var i: Int = 0
    
    while i < 6 {
        let cs1 = arr[i]
        let cs2 = arr[i+1]
        
        guard let c1 = char_to_hex(cs1) else {
            return Color.black
        }

        guard let c2 = char_to_hex(cs2) else {
            return Color.black
        }
        
        rgb.append((c1 << 4) | c2)
        i += 2
    }

    return Color.init(
        .sRGB,
        red: Double(rgb[0]) / 255,
        green: Double(rgb[1]) / 255,
        blue:  Double(rgb[2]) / 255,
        opacity: 1
    )
}
