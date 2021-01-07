//
//  ContentView.swift
//  WordScramble
//
//  Created by Tajwar Rahman on 12/28/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]() // list of used words
    @State private var rootWord = "" // the main word the user is supposed to make words from
    @State private var newWord = "" // the word the user types in
    @State private var score = 0
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    var body: some View {
        NavigationView{
            VStack{
                // place where the user writes the word; will be lowercased
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                // list of words the user wrote
                List(usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                        
                        GeometryReader { fullView in
                            ScrollView(.vertical) {
                                ForEach(0..<self.usedWords.count - 1) { index in
                                    GeometryReader { geo in
                                        HStack {
                                            Image(systemName: "\(self.usedWords[index].count).circle")
                                            Text("\(self.usedWords[index])")
                                                .font(.title)
                                        }
                                        .frame(width: fullView.size.width, alignment: Alignment.leading)
                                        .offset(x: (geo.frame(in: .global).midY / (fullView.size.height / 50)),
                                                y: 0)
                                    }
                                    .frame(height: 40)
                                }
                            }
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("\(word), \(word.count) letters"))
                }
                
                // user score
                Text("Your score is: \(score)").font(.title).fontWeight(.bold)
            }
            .navigationBarTitle(rootWord)
            // a button to change the word
            .navigationBarItems(leading: Button(action: startGame){
                    Text("New Word").foregroundColor(.blue)
                })
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        // the guards are series of checks to make sure the word the user writes meets the criterias
        guard answer.count > 0 else {
            return
        }
        
        guard isRoot(word: answer) else{
            wordError(title: "Word given", message: "You can't use the root word")
            return
        }
        
        guard isOriginal(word: answer) else{
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else{
            wordError(title: "Word not recognized", message: "You can't make em up")
            return
        }
        
        guard isRealWord(word: answer) else{
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }
        
        usedWords.insert(answer, at: 0) // add the word to the top of the list
        score += usedWords.count * newWord.count // multiply the length of the list by the length of the word they wrote and add it to their score
        newWord = "" // makes text field empty
    }
    
    func startGame() {
        // gives a random word
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                score = 0
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    // checks to see repeated words
    func isOriginal(word: String) -> Bool{
        return !usedWords.contains(word)
    }
    
    // checks to see if correct letters are used
    func isPossible(word: String) -> Bool{
        var temp = rootWord.lowercased()
        
        for letter in word{
            if let pos = temp.firstIndex(of: letter){
                temp.remove(at: pos)
            }
            else{
                return false
            }
        }
        return true
    }
    
    // checks to see if the word is misspelled and if the length of word is >= 3
    func isRealWord(word: String) -> Bool{
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return mispelledRange.location == NSNotFound && word.count >= 3
    }
    
    // checks to see if the word is the same as the root word
    func isRoot(word: String) -> Bool {
        return !(rootWord.lowercased() == word)
    }
    
    // function for creating an error alert if the word fails the checks
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
