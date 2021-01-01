//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Tajwar Rahman on 12/31/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

// emojis in the main screen reflecting the rating of the book
struct EmojiRatingView: View {
    let rating: Int16
    var body: some View {
        switch rating {
        case 1:
            return Text("😴")
        case 2:
            return Text("☹️")
        case 3:
            return Text("😑")
        case 4:
            return Text("😃")
        default:
            return Text("🤩")
        }
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
