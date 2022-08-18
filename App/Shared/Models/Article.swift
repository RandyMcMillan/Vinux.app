//
//  Article.swift
//  Universal App (iOS)
//
//  Created by Can Balkaya on 12/10/20.
//

import Foundation

struct Article: Identifiable {
    
    // MARK: - Properties
    var id = UUID()
    let title: String
    let description: String
    let type: String
}

let Nostr = [
    Article(title: "What is Nostr?", description: "The simplest open protocol that is able to create a censorship-resistant global \"social\" network once and for all. It doesn't rely on any trusted central server, hence it is resilient; it is based on cryptographic keys and signatures, so it is tamperproof; it does not rely on P2P techniques, therefore it works.", type: "Nostr"),
    Article(title: "How does it work?", description: "Very short summary of how it works, if you don't plan to read anything else: Everybody runs a client. It can be a native client, a web client, etc. To publish something, you write a post, sign it with your key and send it to multiple relays (servers hosted by someone else, or yourself). To get updates from other people, you ask multiple relays if they know anything about these other people. Anyone can run a relay. A relay is very simple and dumb. It does nothing besides accepting posts from some people and forwarding to others. Relays don't have to be trusted. Signatures are verified on the client side.", type: "Nostr"),
    Article(title: "How does it work?", description: "Very short summary of how it works, if you don't plan to read anything else: Everybody runs a client. It can be a native client, a web client, etc. To publish something, you write a post, sign it with your key and send it to multiple relays (servers hosted by someone else, or yourself). To get updates from other people, you ask multiple relays if they know anything about these other people. Anyone can run a relay. A relay is very simple and dumb. It does nothing besides accepting posts from some people and forwarding to others. Relays don't have to be trusted. Signatures are verified on the client side.", type: "Nostr"),
    Article(title: "How does it work?", description: "Very short summary of how it works, if you don't plan to read anything else: Everybody runs a client. It can be a native client, a web client, etc. To publish something, you write a post, sign it with your key and send it to multiple relays (servers hosted by someone else, or yourself). To get updates from other people, you ask multiple relays if they know anything about these other people. Anyone can run a relay. A relay is very simple and dumb. It does nothing besides accepting posts from some people and forwarding to others. Relays don't have to be trusted. Signatures are verified on the client side.", type: "Nostr"),
]

let scienceArticles = [
    Article(title: "Are Apple Products Becoming More Cheaper?", description: "In recent years, when I looked at the price of Apple's newly introduced products, I saw a slight decrease in the price of new products.", type: "Science"),
    Article(title: "Limit Properties", description: "Limits can also be evaluated using the properties of limits.", type: "Science"),
    Article(title: "Direct Substitution", description: "We can find any limit of a definite function with direct substitution. Let’s find out how we can do this!", type: "Science")
]

let designArticles = [
    Article(title: "Euler Number", description: "What is the number of e that we usually encounter in calculators? What does it do? Let’s find out what this number is!", type: "Design"),
    Article(title: "Introduction of Limits", description: "Now that we have defined the limit, let’s try to better understand the limit by giving an example…", type: "Design"),
    Article(title: "Find Limits Using Graphs", description: "Graphs are a great tool for understanding the approaching values. Let’s see how this happens!", type: "Design"),
    Article(title: "Find Limits Using Tables", description: "A noteworthy method to understand limits. How, you ask?", type: "Design")
]
