//
//  HelpView 2.swift
//  BetaBay
//
//  Created by Sayan on 04.07.2025.
//


//
//  HelpView.swift
//  BetaBay
//
//  Created by Sayan on 04.07.2025.
//


import SwiftUI

struct HelpView: View {
    var body: some View {
        NavigationView {
            BetaBayWebView(urlString: "https://betabay.app/help")
                .navigationTitle("Help & Support")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
