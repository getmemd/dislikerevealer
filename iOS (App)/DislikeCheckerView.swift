//
//  DislikeCheckerView.swift
//  DislikeRevealer (iOS)
//
//  Created by Adilkhan Medeuyev on 14.12.2024.
//

import SwiftUI

struct DislikeCheckerView: View {
    @State private var url: String = ""
    @State private var dislikeCounter: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(.logo)
                .resizable()
                .frame(width: 200, height: 60)
            Spacer()
            VStack(spacing: 24) {
                TextField("Paste URL here", text: $url)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#575757"), lineWidth: 1)
                    }
                Button {
                    Task {
                        do {
                            dislikeCounter = try await fetchDislikeCount(from: url)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Check")
                        .font(.headline).bold()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.red)
                        .cornerRadius(16)
                }
                VStack {
                    Text("The number of dislikes on a video:")
                        .font(.title3)
                        .padding()
                    Divider()
                        .overlay{
                            Color(hex: "#575757")
                        }
                    HStack(spacing: 8) {
                        Image(systemName: "hand.thumbsdown.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.red)
                        Text(dislikeCounter.description)
                            .font(.title).bold()
                            .foregroundStyle(.red)
                            .padding()
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "#575757"), lineWidth: 1)
                }
            }
            Spacer()
        }
        .padding()
    }

    private func extractYouTubeVideoID(from url: String) -> String? {
        let pattern = #"^.*(youtu\.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*"#
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: url.utf16.count)
            if let match = regex.firstMatch(in: url, options: [], range: range) {
                if let videoIDRange = Range(match.range(at: 2), in: url) {
                    let videoID = url[videoIDRange]
                    if videoID.count == 11 {
                        return String(videoID)
                    }
                }
            }
        } catch {
            print("Invalid regular expression: \(error.localizedDescription)")
        }
        return nil
    }

    private func fetchDislikeCount(from videoURL: String) async throws -> Int {
        guard let videoID = extractYouTubeVideoID(from: videoURL) else {
            throw NSError(domain: "Invalid URL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to extract videoId from URL"])
        }
        let apiURLString = "https://returnyoutubedislikeapi.com/votes?videoId=\(videoID)"
        guard let apiURL = URL(string: apiURLString) else {
            throw NSError(domain: "Invalid API URL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid API URL"])
        }
        let (data, _) = try await URLSession.shared.data(from: apiURL)
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let dislikes = json["dislikes"] as? Int else {
            throw NSError(domain: "Parsing Error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Couldn't parse JSON or find dislike data"])
        }
        return dislikes
    }

}

#Preview {
    DislikeCheckerView()
}
