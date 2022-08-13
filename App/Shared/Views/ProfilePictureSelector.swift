//
//  ProfilePictureSelector.swift
//  damus
//
//  Created by William Casarin on 2022-05-20.
//

import SwiftUI

struct ProfilePictureSelector: View {
    let pubkey: String
    
    var body: some View {
        let highlight: Highlight = .custom(Color.white, 2.0)
        ZStack {
            /*
            Image(systemName: "camera")
                .font(.title)
                .foregroundColor(.white)
             */

#if !os(macOS)
            ProfilePicView(pubkey: pubkey, size: 80.0, highlight: highlight, image_cache: ImageCache(), profiles: Profiles())
#else
            ProfilePicView(pubkey: pubkey, size: 80.0, highlight: highlight, profiles: Profiles())
#endif
        }
    }
}

struct ProfilePictureSelector_Previews: PreviewProvider {
    static var previews: some View {
        let test_pubkey = "7bc0ff3de7b2205ed8bc366f7657138eacb5164d43d9580b8f5b47b7e6a7c235"
        ProfilePictureSelector(pubkey: test_pubkey)
    }
}
