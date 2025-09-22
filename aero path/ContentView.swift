//
//  ContentView.swift
//  aero path
//
//  Created by Vitalii Shevtsov on 20.09.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showLaunchScreen = true
    @State private var viewModel = AeroPathViewModel()
    
    var body: some View {
        ZStack {
            if showLaunchScreen {
                LaunchScreenView()
                    .transition(.opacity)
            } else {
                MainTabView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Show launch screen for 2.5 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showLaunchScreen = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
