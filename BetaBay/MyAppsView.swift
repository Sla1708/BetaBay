//
//  PrivacyView.swift
//  BetaBay
//
//  Created by Sayan on 04.07.2025.
//


import SwiftUI

struct PrivacyView: View {
    var body: some View {
        NavigationView {
            BetaBayWebView(urlString: "https://app.beta-bay.com/myapps")
                .navigationTitle("My Apps")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
