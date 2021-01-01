//
//  DetailView.Swift
//  Bookworm
//
//  Created by Tajwar Rahman on 1/1/21.
//  Copyright © 2021 Tajwar Rahman. All rights reserved.
//

import CoreData
import SwiftUI

struct DetailView: View {
    // these properties will be used to delete the book the user is currently looking at
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    // adding date formatter
    var dateFormatter: DateFormatter {
        let formater = DateFormatter()
        formater.dateStyle = .long
        return formater
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    // image of genre followed by a small text describing the genre
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geo.size.width)
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown author")
                    .font(.title)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                
                Text(self.book.review ?? "No review")
                    .padding()
                
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                    .padding()
                
                // formatted date on the bottom
                Text("Added on: ").font(.headline).fontWeight(.black)
                Text("\(self.book.date ?? Date(), formatter: self.dateFormatter)")
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(self.book.title ?? "Unknown Title"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete book"), message: Text("Are you sure you want to delete \(self.book.title ?? "this book")?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteBook()
                }, secondaryButton: .cancel())
        }
            // a trash button for deleting book
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
    }
    
    // deletes the book
    func deleteBook(){
        moc.delete(book)
        try? moc.save()
        presentationMode.wrappedValue.dismiss()
        
    }
}

struct DetailView_Previews: PreviewProvider {
    // creating managed object context
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType) // using main thread
    
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This is a great book, I really enjoyed it."
        book.date = Date()
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
