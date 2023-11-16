//
//  ContentView.swift
//  exam3practic Watch App
//
//  Created by brian waobikeze on 11/14/23.
//

import SwiftUI

struct ContentView: View {
    private var syncService = SyncService()
    @State private var data: String = ""
    @State private var receivedData: [String] = []
    @State private var avatarImage: UIImage?
    // var moodArray = ["🤔","😊","🤨","😫"]
    // var objArray = ["❓","🏠","💻","🚗"]
    // @State var moodIdx = 0
    // @State var objIdx = 0

    var body: some View {
        VStack {
            Image(uiImage: avatarImage ?? UIImage(systemName: "person.crop.circle") ?? UIImage())
                .resizable()
                .scaledToFit()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .background(.white)
                .clipShape(Circle())
        }
        .padding()
        // .onAppear { syncService.dataReceived = Receive }
    }

    // private func Receive(key: String, value: Any) -> Void {
    //     self.receivedData.append("\(Date().formatted(date: .omitted, time: .standard)) - \(key):\(value)")
    //     print("Hi im here")
    //     self.objIdx = Int("\(value)") ?? 0
    // }
}


#Preview {
    ContentView()
}
