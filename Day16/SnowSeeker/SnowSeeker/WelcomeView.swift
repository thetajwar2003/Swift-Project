//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Tajwar Rahman on 1/6/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker").font(.largeTitle)
            
            Text("PLease select a resort from the left-hand menu; swipe fromt he left edge to show it.") .foregroundColor(.secondary)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
