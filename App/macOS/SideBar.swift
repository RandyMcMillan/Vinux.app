//
//  SideBar.swift
//  Universal App (macOS)
//
//  Created by Can Balkaya on 12/10/20.
//

import SwiftUI

enum NavigationItem {
    case tech
    case science
    case design
}

struct SideBar: View {

    // MARK: - Properties
    @State var selection: Set<NavigationItem> = [.tech]
    @State var listStyle = DefaultListStyle()

    // MARK: - GUI Nav Entrypint
    @ViewBuilder
    var body: some View {
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
        .navigationTitle("Articles")
        .listStyle(listStyle)
        .frame(
            // minWidth:    UIScreen.main.bounds.width*0.10,
            // idealWidth:  UIScreen.main.bounds.width*0.33,
            // maxWidth:    UIScreen.main.bounds.width*0.5,
            // minHeight:   UIScreen.main.bounds.width*0.10,
            // idealHeight: UIScreen.main.bounds.width*0.20,
            // maxHeight:   UIScreen.main.bounds.width*0.50,
            alignment:   .leading
            )
    }

}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        SideBar()
    }
}
