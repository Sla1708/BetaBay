//
//  WebsiteView.swift
//  BetaBay
//
//  Created by Sayan on 04.07.2025.
//


import SwiftUI

struct JoinedTestsView: View {
    var body: some View {
        NavigationView {
            BetaBayWebView(urlString: "https://app.beta-bay.com/joined")
                .navigationTitle("Joined Tests")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
