//
//  ThreadView.swift
//  damus
//
//  Created by William Casarin on 2022-04-19.
//

import SwiftUI


struct ThreadView: View {
    @State var is_chatroom: Bool = false
    @StateObject var thread: ThreadModel
    let damus: DamusState
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Group {
            if is_chatroom {
                ChatroomView(damus: damus)
                    #if !os(macOS)
                    .navigationBarTitle("ThreadView Chat")
                    #endif
                    .environmentObject(thread)
            } else {
                EventDetailView(damus: damus, thread: thread)
                    #if !os(macOS)
                    .navigationBarTitle("EventDetailView Thread")
                    #endif
                    .navigationTitle("EventDetailView Thread")
                    .environmentObject(thread)
            }
            
            /*
            NavigationLink(destination: edv, isActive: $is_chatroom) {
                EmptyView()
            }
             */
        }
        .padding([.leading, .trailing], 200)
        .onReceive(NotificationCenter.default.publisher(for: .switched_timeline)) { n in
            dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: .toggle_thread_view)) { _ in
            is_chatroom = !is_chatroom
            //print("is_chatroom: \(is_chatroom)")
        }
        .onAppear() {
            thread.subscribe()
        }
        .onDisappear() {
            thread.unsubscribe()
        }
    }
}

/*
struct ThreadView_Previews: PreviewProvider {
    static var previews: some View {
        ThreadView()
    }
}
*/
