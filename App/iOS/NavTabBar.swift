//
//  TabBar.swift
//  Universal App (iOS)
//
//  Created by Can Balkaya on 12/10/20.
//

import SwiftUI

struct NavTabBar: View {
    
    // MARK: - GUI Nav Entrypint
    // MARK: - TabBar
    var body: some View {
        TabView {
            ArticlesListView(articles: Nostr)
                .tabItem {
                    Image(systemName: "newspaper.fill")
                    Text("Tech")
                }
                .tag(0)
            
            ArticlesListView(articles: scienceArticles)
                .tabItem {
                    Image(systemName: "paperclip")
                    Text("Science")
                }
                .tag(1)
            
            ArticlesListView(articles: designArticles)
                .tabItem {
                    Image(systemName: "rectangle.and.paperclip")
                    Text("Design")
                }
                .tag(2)
        }
        .navigationTitle("Articles")
    }
}

struct NavTabBar_Previews: PreviewProvider {
    static var previews: some View {
        NavTabBar()
    }
}
