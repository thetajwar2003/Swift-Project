//
//  UserDetailSheet.swift
//  Buddy
//
//  Created by Tajwar Rahman on 1/1/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

// provides some info about the user
struct UserDetailSheet: View {
    var allUsers: [User]
    var friends: [User.Friends]
    var currentUser: User


    var body: some View {
        NavigationView {
            VStack {
                HStack(alignment: .center) {
                    HStack {
                         // email
                        Image(systemName: "envelope.badge.fill")
                        Text(currentUser.email)
                    }
                    
                    HStack {
                        // company
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
                
                // user tags
                Text("Tags:")
                    .font(.title)
                    .fontWeight(.black)
                VStack {
                    ForEach(currentUser.tags, id: \.self) { tag in
                        Text("  \(tag)  ")
                        .padding(3)
                        .background(Color.blue.opacity(0.60))
                        .cornerRadius(10)
                    }
                }
            }
            .navigationBarTitle(Text(currentUser.name), displayMode: .inline)
            .navigationBarItems(trailing: NavigationLink(destination: UserDetailView(allUsers: self.allUsers, friends: self.friends, currentUser: currentUser)) {
                Text("More Info")
            })
        }
    }
}

