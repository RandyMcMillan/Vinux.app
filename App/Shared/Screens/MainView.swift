//
//  MainView.swift
//  Universal App
//
//  Created by Can Balkaya on 12/11/20.
//

import SwiftUI
import Introspect

var numberFormatter = NumberFormatter()
extension CGFloat {
    var sf2:String {
        get {
            // numberFormatter.numberStyle.rawValue.formatted()// = NumberFormatStyleConfiguration.Precision.significantDigits(2)
            numberFormatter.maximumSignificantDigits = 2
            print(numberFormatter.string(for: self)!)
            return numberFormatter.string(for: self)!
        }
    }
}

// class MainViewController: UIViewController {
//
//     // Screen width.
//     func screenWidth() -> CGFloat {
//         let x = CGFloat(5.23325)
//         print("The value of x is \(x.sf2)")
//         return UIScreen.main.bounds.width
//     }
//     // Screen height.
//     func screenHeight() -> CGFloat {
//         return UIScreen.main.bounds.height
//     }
//
//     var textView:UITextView?
//
//     override func viewDidLoad() {
//         super.viewDidLoad()
//     }
//
//     override func viewWillAppear(_ animated: Bool) {
//         super.viewWillAppear(animated)
//
//         determineMyDeviceOrientation()
//     }
//
//     func determineMyDeviceOrientation()
//     {
//         if UIDevice.current.orientation.isLandscape {
//             print("Device is in landscape mode")
//         } else {
//             print("Device is in portrait mode")
//         }
//     }
//     override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//
//         let _ = screenWidth()
//         determineMyDeviceOrientation()
//     }
//
//     override func didReceiveMemoryWarning() {
//         super.didReceiveMemoryWarning()
//         // Dispose of any resources that can be recreated.
//     }
//
// }

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
            }
            //.introspectSplitViewController { controller in
                  // some examples
                  // controller.preferredSupplementaryColumnWidthFraction = 2
                  // controller.preferredPrimaryColumnWidth = 180
                  // controller.preferredDisplayMode = .twoBesideSecondary
                  //controller.presentsWithGesture = false
            //}



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
