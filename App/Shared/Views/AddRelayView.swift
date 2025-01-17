//
//  AddRelayView.swift
//  damus
//
//  Created by William Casarin on 2022-06-09.
//

import SwiftUI

struct AddRelayView: View {
    @Binding var show_add_relay: Bool
    @Binding var relay: String
    
    let action: (String?) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section("Add Relay") {
                    TextField("wss://some.relay.com", text: $relay)
#if !os(macOS)
                        .textInputAutocapitalization(.never)
#endif
                }
            }
            
            VStack {
                HStack {
                    Button("Cancel") {
                        show_add_relay = false
                        action(nil)
                    }
                    .contentShape(Rectangle())
                    
                    Spacer()
                    
                    Button("Add") {
                        show_add_relay = false
                        action(relay)
                    }
                    .buttonStyle(.borderedProminent)
                    .contentShape(Rectangle())
                }
                .padding()
            }
        }
    }
}

struct AddRelayView_Previews: PreviewProvider {
    @State static var show: Bool = true
    @State static var relay: String = ""
    
    static var previews: some View {
        AddRelayView(show_add_relay: $show, relay: $relay, action: {_ in })
    }
}
