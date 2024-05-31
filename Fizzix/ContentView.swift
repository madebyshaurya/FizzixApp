//
//  ContentView.swift
//  Fizzix
//
//  Created by Shaurya on 2024-05-31.
//

import SwiftUI
import CoreText

struct ContentView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.white)
                    .ignoresSafeArea(.all)
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                    .opacity(0.1)
                    HomeView()
            }
        }
    }
}

#Preview {
    ContentView()
}



