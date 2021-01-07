//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Tajwar Rahman on 1/6/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ResortView: View {
    @Environment(\.horizontalSizeClass) var sizeClass
    @EnvironmentObject var favorites: Favorites
    @State private var selectedFacility: Facility?
    
    let resort: Resort
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack (alignment: .bottomTrailing) {
                    Image(decorative: resort.id)
                        .resizable()
                        .scaledToFit()
                    Text(resort.imageCredit)
                        .font(.caption)
                        .fontWeight(.black)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Group {
                    HStack {
                        if sizeClass == .compact {
                            Spacer()
                            VStack { ResortDetailView(resort: resort) }
                            VStack { SkiDetailedView(resort: resort) }
                            Spacer()
                        }
                        else {
                            ResortDetailView(resort: resort)
                            Spacer().frame(height: 0)
                            SkiDetailedView(resort: resort)
                        }
                    }
                    .font(.headline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                    
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            facility.icon
                                .font(.title)
                                .onTapGesture {
                                    self.selectedFacility = facility
                            }
                        }
                    }
                    .padding(.vertical)
                }.padding(.horizontal)
                
                Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                    if self.favorites.contains(self.resort) {
                        self.favorites.remove(self.resort)
                    } else {
                        self.favorites.add(self.resort)
                    }
                }
                .padding()
            }
            .alert(item: $selectedFacility) { facility in
                facility.alert
            }
            .navigationBarTitle(Text("\(resort.name), \(resort.country)"), displayMode: .inline)
        }
    }
}

//extension String: Identifiable {
//    public var id: String { self }
//}

struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        ResortView(resort: Resort.example)
    }
}
