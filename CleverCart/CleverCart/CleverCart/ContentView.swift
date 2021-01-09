//
//  ContentView.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var username = "" // change to userdefault.username ?? ""
    @State private var password = "" // change to userdefault.password ?? ""
    
    @State private var showingSignUp = false
    
    var body: some View {
        NavigationView {
            VStack (alignment: .center) {
                TextField("Username", text: $username)
                TextField("Password", text: $password)
            
                
                Button("Sign Up") {
                    self.showingSignUp.toggle()
                }
                NavigationLink(destination: Text("temp")) {
                    Text("Login")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue.opacity(0.75))
                        .clipShape(Capsule())
                }
            }
            .sheet(isPresented: $showingSignUp) {
                SignUp()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
