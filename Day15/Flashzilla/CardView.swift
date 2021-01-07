//
//  CardView.swift
//  Flashzilla
//
//  Created by Tajwar Rahman on 1/6/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    let card : Card
    var removal: (() -> Void)? = nil
    
    @State private var isShowingAnswer = false
    @State private var offset = CGSize.zero
    @State private var feedback = UINotificationFeedbackGenerator()
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    differentiateWithoutColor
                        ? Color.white
                        : Color.white
                            .opacity(1 - Double(abs(offset.width / 50))) // this means that the card will immediately change color
                )
                .background(
                    differentiateWithoutColor
                        ? nil
                        : RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(offset.width > 0 ? Color.green : Color.red) // if the card is moved to the right it is green and correct else it is wrong and red
                )
                .shadow(radius: 10)
            
            VStack {
                if accessibilityEnabled {
                    Text(isShowingAnswer ? card.answer : card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }
                else {
                    Text(card.prompt)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                    if isShowingAnswer {
                        Text(card.answer)
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(Double(offset.width / 5))) // makes sure that the angle is changing with offset
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50))) // makes sure that the card is still opaque up until 50 points
        .accessibility(addTraits: .isButton) // voice over tells the user that the card is a button
        // checks which direction the card is being swiped at
        .gesture(
            DragGesture()
                .onChanged{ gesture in
                    self.offset = gesture.translation
                    self.feedback.prepare() // prepares the haptics 
            }
            .onEnded { _ in
                if abs(self.offset.width) > 100 {
                    if self.offset.width > 0 {
                        self.feedback.notificationOccurred(.success)
                    }
                    else {
                        self.feedback.notificationOccurred(.error)
                    }
                    self.removal?()
                }
                else {
                    self.offset = .zero
                }
            }
                    
        )
        .onTapGesture {
            self.isShowingAnswer = true
        }
        .animation(.spring())
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: Card.example)
    }
}
