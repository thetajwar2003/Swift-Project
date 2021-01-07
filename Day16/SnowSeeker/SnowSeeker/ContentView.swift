//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Tajwar Rahman on 1/6/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import SwiftUI

enum Sort {
    case defaults, alphabetically, country
}

enum Filter {
    case fr, us, it, au, ca, all
}

struct ContentView: View {
    @State private var showingFilter = false
    @State private var filtered: Filter = .all
    
    @State private var showingSort = false
    @State private var sorted: Sort = .defaults
    
    var resorts: [Resort] {
        let data: [Resort] = Bundle.main.decode("resorts.json")
        var filter = data
        
        switch filtered {
            case .us:
                filter = data.filter { $0.country == "United States"}
            case .au:
                filter = data.filter { $0.country == "Austria"}
            case .fr:
                filter = data.filter { $0.country == "France"}
            case .ca:
                filter = data.filter { $0.country == "Canada"}
            case .it:
                filter = data.filter { $0.country == "Italy"}
            case .all:
                filter = data
        }
        
        switch sorted {
            case .defaults:
                return filter
            case .alphabetically:
                return filter.sorted { $0.name < $1.name }
            case .country:
                return filter.sorted { $0.country < $1.country }
        }
    }
    @ObservedObject var favorites = Favorites()
    
    var body: some View {
        NavigationView {
            List(resorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)){
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 24)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        ).overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )
                    VStack(alignment: .leading) {
                        Text(resort.name).font(.headline)
                        
                        Text("\(resort.runs) runs").foregroundColor(.secondary)
                    }.layoutPriority(1)
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                        .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(leading: Button("Sort"){
                self.showingSort.toggle()
                }, trailing: Button("Filter"){
                    self.showingFilter.toggle()
            })
            
                .actionSheet(isPresented: $showingFilter) {
                    ActionSheet(title: Text("Filter Country"), message: Text("Select which country to filter"), buttons: [
                            .default(Text("France")) { self.filtered = .fr },
                            .default(Text("United States")) { self.filtered = .us },
                            .default(Text("Italy")) { self.filtered = .it },
                            .default(Text("Austria")) { self.filtered = .au },
                            .default(Text("Canada")) { self.filtered = .ca },
                            .default(Text("All")) { self.filtered = .all },
                            .cancel()
                        ])
                }
            WelcomeView()
        }
//        .phoneOnlyStackNavigationView()
        .environmentObject(favorites)
        .actionSheet(isPresented: $showingSort) {
            ActionSheet(title: Text("Sort"), message: Text("Select sorting style"), buttons: [
                .default(Text("Sort by default")) { self.sorted = .defaults },
                .default(Text("Sort alphabetically")) { self.sorted = .alphabetically },
                .default(Text("Sort by country")) { self.sorted = .country },
                .cancel()
            ])
        }
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
