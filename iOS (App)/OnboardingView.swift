//
//  OnboardingView.swift
//  DislikeRevealer (iOS)
//
//  Created by Adilkhan Medeuyev on 14.12.2024.
//

import SwiftUI

struct OnboardingView: View {
    enum OnboardingPage: CaseIterable {
        case browser
        case inapp
        case settings
        
        var title: String {
            switch self {
            case .browser:
                return "Bring Back\nthe Dislike Counter"
            case .inapp:
                return "Or paste it into the app\nto check out dislikes"
            case .settings:
                return "How to enable\nSafari Extension?"
            }
        }
        
        var image: ImageResource {
            switch self {
            case .browser:
                return .screenshot1
            case .inapp:
                return .screenshot2
            case .settings:
                return .screenshot3
            }
        }
    }
    
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var currentPage = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(Array(OnboardingPage.allCases.enumerated()), id: \.offset) { (index, page) in
                    VStack {
                        ZStack {
                            if index == 2 {
                                HStack {
                                    Spacer()
                                    Button {
                                        hasSeenOnboarding = true
                                    } label: {
                                        Image(systemName: "x.square")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                    .padding()
                                }
                            }
                            Text(page.title)
                                .font(.title).bold()
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                        Image(page.image)
                            .resizable()
                            .scaledToFit()
                            .padding()
                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(
                PageTabViewStyle(indexDisplayMode: .always)
            )
            .tint(.red)
            .accentColor(.red)
            Button {
                withAnimation {
                    if currentPage >= 2 {
                        openSettings()
                    } else {
                        currentPage += 1
                    }
                }
            } label: {
                Text(currentPage != 2 ? "Next" : "Open Settings")
                    .font(.headline).bold()
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.red)
                    .cornerRadius(12)
            }
            .padding()
        }
    }
    
    private func openSettings() {
        if let url = URL(string: "App-Prefs:com.apple.mobilesafari& path=WEB_EXTENSIONS") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Cannot open Safari settings")
            }
        } else {
            print("Invalid URL for Safari settings")
        }
    }
}

#Preview {
    OnboardingView()
}
