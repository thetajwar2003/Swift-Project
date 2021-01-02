//
//  ContentView.swift
//  Buddy
//
//  Created by Tajwar Rahman on 1/1/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()
    @State private var showingSheet = false
    @State private var selectedUser: User? = nil
    @State private var selectedUsersFriends: [User.Friends]? = nil
    var body: some View {
        NavigationView{
            List {
                ForEach(users, id: \.id) { user in
                    NavigationLink(destination: UserDetailView(allUsers: self.users, friends: user.friends, currentUser: user)) {
                        HStack {
                            // show whether the user is active with a green/gray circle
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundColor(user.isActive ? .green : .gray)
                            // tap on the user for a small sheet about the user
                            Text(user.name)
                                .fontWeight(.medium)
                                .onTapGesture {
                                self.selectedUser = user
                                self.selectedUsersFriends = user.friends
                                self.showingSheet.toggle()
                            }
                            Text("|").foregroundColor(.secondary)
                            Text("Age: \(user.age)")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .sheet(isPresented: self.$showingSheet) {
                UserDetailSheet(allUsers: self.users, friends: self.selectedUsersFriends!, currentUser: self.selectedUser!)
            }
            .navigationBarTitle(Text("Buddy"), displayMode: .inline)
        }.onAppear(perform: getData) // gets data when the app is started
    }
    
    func getData() {
        // fetch the url
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Error fetching url")
            return
        }
        
        let request = URLRequest(url: url)
        
        // store the data we fetched into our properties
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decoded = try? JSONDecoder().decode([User].self, from: data){
                    DispatchQueue.main.async {
                        self.users = decoded
                    }
                    return
                }
            }
             print("Fetch Failed \(error?.localizedDescription  ?? "Unknown Error")")
        }.resume()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
