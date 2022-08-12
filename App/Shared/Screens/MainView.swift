//
//  MainView.swift
//  Universal App
//
//  Created by Can Balkaya on 12/11/20.
//

import SwiftUI

struct MainView: View {

    @State var needs_setup = false;
    @State var keypair: Keypair? = nil;

        // MARK: - Properties
        #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
        @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
        #endif

        // MARK: - UI Elements
        @ViewBuilder
        var body: some View {

        Group {
            if let kp = keypair, !needs_setup {

            NavigationView {


                #if os(iOS)
                if horizontalSizeClass == .compact //narrow screen
                {

                    TabBar()

                }
                else
                {

                    SideBar()
                    TabBar()

                }


                #else // not iOS


                SideBar()
                // ArticlesListView(articles: techArticles)


                #endif
            }//End NavigationView

            } else {

                Text("MainView.swift @ViewBulder before SetupView()")
                ZStack {
                Text("left")
                SetupView()
                    .onReceive(handle_notify(.login)) { notif in
                        needs_setup = false
                        keypair = get_saved_keypair()
                    }

                Text("right")
                }
                Text("MainView.swift @ViewBulder after SetupView()")
            }

            }// End Group
        }//End body View
    }// End MainView View

    struct MainView_Previews: PreviewProvider {
        static var previews: some View {
            MainView()
        }
    }

//
//    @State var needs_setup = false;
//    @State var keypair: Keypair? = nil;
//
//    // MARK: - Properties
//    #if os(iOS)
//    // @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
//    #endif
//
//    // MARK: - GUI Entrypoint
//    @ViewBuilder
//    var body: some View {
//        Text("MainView.swift @ViewBulder body")
//        HStack {
//                // Text("MainView.swift @ViewBulder HStack")
//        TabBar()
//                Text("MainView.swift @ViewBulder after TabBar()")
//        Group {
//            if let kp = keypair, !needs_setup {
//                Text("MainView.swift @ViewBulder Group")
//                ContentView(keypair: kp)
//                Text("MainView.swift @ViewBulder after ContentView()")
//                   // .frame(minWidth: 600, minHeight: 600)
//
//            } else {
//
//                SetupView()
//                    .onReceive(handle_notify(.login)) { notif in
//                        needs_setup = false
//                        keypair = get_saved_keypair()
//                    }
//                Text("MainView.swift @ViewBulder after SetupView()")
//            }
//        }//End Group
//        .onReceive(handle_notify(.logout)) { _ in
//            keypair = nil
//        }//End onRecieve
//        .onAppear {
//            keypair = get_saved_keypair()
//        }// End onAppear
//        }// End HStack
//        .onAppear(){}
//    }//End body View
//}// End MainView View
//
//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
//
func needs_setup() -> Keypair? {
    return get_saved_keypair()
}
