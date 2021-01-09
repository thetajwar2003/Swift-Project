//
//  SignUp.swift
//  CleverCart
//
//  Created by Tajwar Rahman on 1/8/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct SignUp: View {
    @State private var username = "" // change to userdefault.username ?? ""
    @State private var password = "" // change to userdefault.password ?? ""
    
    var body: some View {
        NavigationView {
            VStack () {
                TextField("Username", text: $username)
                TextField("Password", text: $password)
            
                NavigationLink(destination: Text("sign up temp")) {
                    Text("Login")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue.opacity(0.75))
                        .clipShape(Capsule())
                }
            }
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
