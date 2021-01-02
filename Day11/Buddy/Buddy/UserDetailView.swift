//
//  UserDetailView.swift
//  Buddy
//
//  Created by Tajwar Rahman on 1/1/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct UserDetailView: View {
    var allUsers: [User]
    var friends: [User.Friends]
    var currentUser: User
    
    @State public var selectedFriend: User? = nil
    @State public var showingFriend = false
    
    var body: some View {
        NavigationView {
            VStack() {
                HStack(alignment: .center) {
                    
                    // email
                    HStack {
                        Image(systemName: "envelope.badge.fill")
                        Text(currentUser.email)
                    }
                    
                    // company
                    HStack {
                        Image(systemName: "desktopcomputer")
                        Text(currentUser.company)
                    }
                }
                
                // address
                HStack {
                    Image(systemName: "map.fill")
                    Text(currentUser.address)
                }
                
                // when the user registered
                HStack {
                    Image(systemName: "clock.fill")
                        Text(currentUser.registered)
                }
                
                // about the user
                Text("About: ")
                    .font(.title)
                    .fontWeight(.black)
                
                Text(currentUser.about)
                    .padding()
                    .multilineTextAlignment(.center)
                
                // list of user's friends that you can also click on the name and get more info on them
                Text("Friends:")
                    .font(.title)
                    .fontWeight(.black)
                
                List(friends, id: \.id) { friend in
                    ForEach(self.allUsers) { user in
                        if user.id == friend.id {
                           HStack {
                                Circle()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(user.isActive ? .green : .gray)
                                Text(user.name)
                                    .fontWeight(.medium)
                                Text("|").foregroundColor(.secondary)
                                Text("Age: \(user.age)")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }.onTapGesture {
                                self.selectedFriend = user
                                self.showingFriend.toggle()
                            }
                        }
                    }
                }.sheet(isPresented: self.$showingFriend) {
                    UserDetailSheet(allUsers: self.allUsers, friends: self.friends, currentUser: self.currentUser)
                }
            }.navigationBarTitle(Text(currentUser.name), displayMode: .inline)
            
        }
    }
}
