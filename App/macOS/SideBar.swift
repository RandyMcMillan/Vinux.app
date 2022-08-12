//
//  SideBar.swift
//  Universal App (macOS)
//
//  Created by Can Balkaya on 12/10/20.
//

import SwiftUI
import AVFoundation

enum NavigationItem {
    case tech
    case science
    case design
}

struct SideBar: View {

    @State var keypair: Keypair? = get_saved_keypair();
    @State var damus_state: DamusState? = nil
    @State var profile_model: ProfileModel? = nil

    // MARK: - Properties
    @State var selection: Set<NavigationItem> = [.tech]
    @State var listStyle = SidebarListStyle()

#if !os(macOS)
    var width:  CGFloat? = UIScreen.main.bounds.width
    var height: CGFloat? = UIScreen.main.bounds.height
    let screenSize = UIScreen.main.bounds
#endif

    // MARK: - GUI Nav Entrypint
    @ViewBuilder
    var body: some View {

        //print(self.view!.bounds.width)
        // print(self.view!.bounds.height)

        // print(self.frame.size.width)
        // print(self.frame.size.height)


        // detect if window appeared?
        //if let window = self.view!.window {
            // print(self.frame.origin)
        //} else {
            // print("The view is not in a window yet!")
        //}
        if let damus = self.damus_state {
        let profile_model = ProfileModel(pubkey: keypair!.pubkey, damus: damus)
        TinyProfileView(damus_state: damus_state!, profile: profile_model)
        }
        List(selection: $selection) {
            NavigationLink(
                destination: ArticlesListView(articles: techArticles),
                label: {
                    Label("Tech", systemImage: "newspaper.fill")
                }
            )
            .tag(NavigationItem.tech)

            NavigationLink(
                destination: ArticlesListView(articles: scienceArticles),
                label: {
                    Label("Science", systemImage: "paperclip")
                }
            )
            .tag(NavigationItem.science)

            NavigationLink(
                destination: ArticlesListView(articles: designArticles),
                label: {
                    Label("Design", systemImage: "rectangle.and.paperclip")
                }
            )
            .tag(NavigationItem.design)
        }
        .navigationTitle(String(keypair!.pubkey_bech32))
        .listStyle(listStyle)
            #if !os(macOS)
        .frame(
            minWidth:    UIScreen.main.bounds.width*0.05,
            idealWidth:  UIScreen.main.bounds.width*0.15,
            maxWidth:    UIScreen.main.bounds.width*0.2,
            minHeight:   UIScreen.main.bounds.width*0.10,
            idealHeight: UIScreen.main.bounds.width*0.20,
            maxHeight:   UIScreen.main.bounds.width*0.50,
            alignment:   .leading
            )
            #else
        .frame( minWidth: 100.0)
            #endif
    }

}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}
