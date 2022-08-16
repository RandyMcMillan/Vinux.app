//
//  AddHelpView.swift
//  Vinux
//
//  Created by git on 8/16/22.
//

    import SwiftUI

    struct AddHelpView: View {
        @Binding var show_nostr_help: Bool
        @Binding var relay: String

        let action: (String?) -> Void

        var body: some View {
            VStack(alignment: .leading) {

                VStack {
                    HStack {
                        Button("Cancel") {
                            show_nostr_help = false
                            action(nil)
                        }
                        .contentShape(Rectangle())

                        Spacer()
                    }
                    .padding()
                }
            }
        }
    }

    struct AddHelpView_Previews: PreviewProvider {
        @State static var show: Bool = true
        @State static var relay: String = ""

        static var previews: some View {
            AddHelpView(show_nostr_help: $show, relay: $relay, action: {_ in })
        }
    }
