//
//  ContentView.swift
//  Edutainment
//
//  Created by Tajwar Rahman on 12/29/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct Quiz {
    let columns: [Int] = Array(1...12)
    let rows: [Int]
    let questions: [(Int, Int)]

    init(maxRow: Int, totalNumber: Int) {
        self.rows = Array(1...maxRow)
        self.questions = generate(with: rows, columns: columns, totalNumber: totalNumber)
    }
}

func generate(with rows: [Int], columns: [Int], totalNumber: Int) -> [(Int, Int)] {
    let numbers = rows.flatMap { row in
       return columns.map { (row, $0) }
    }.shuffled()

    return totalNumber > 0 ? Array(numbers.prefix(totalNumber)) : numbers
}

struct ContentView: View {
    @State private var maxRow = 1
    @State private var questionIndex = 3
    @State private var score = 0
    @State private var input = ""
    @State private var currentRow = 1
    @State private var currentCol = 1
    @State private var main = true
    @State private var showingMessage = false
    @State private var showingScore = false
    @State private var inc = 0 {
        didSet {
            guard let questions = quiz?.questions, inc > 0 else {
                return
            }
            if inc < questions.count, let(row, col) = quiz?.questions[inc] {
                currentRow = row
                currentCol = col
            } else {
                showingScore = true
            }
        }
    }
    @State private var quiz: Quiz? {
        didSet {
            guard let currentQuiz = quiz, let(row, col) = currentQuiz.questions.first else {
                return
            }
            currentRow = row
            currentCol = col
        }
    }
    let questions = ["5", "10", "20", "All"]


    var body: some View {

        NavigationView {
            Form {
                if main {
                    Group {
                        VStack(alignment: .leading, spacing: 0) {
                            Stepper(value: $maxRow, in: 1...12) {
                                if maxRow == 1 {
                                    Text("\(self.maxRow, specifier: "%i") Row")
                                } else {
                                    Text("\(self.maxRow, specifier: "%i") Rows")
                                }
                            }
                            HStack {
                                Text("How many questions?")
                                Picker("", selection: $questionIndex) {
                                    ForEach(0..<questions.count) {
                                        Text("\(self.questions[$0])")
                                    }
                                }.pickerStyle(SegmentedPickerStyle())
                            }
                        }
                    }
                    Spacer()
                }
                Group {
                    if main {
                        Button("Start") {
                            let totalCount: Int
                            if self.questionIndex == 3 {
                                totalCount = 0
                            } else {
                                totalCount = Int(self.questions[self.questionIndex]) ?? 0
                            }
                            self.quiz = Quiz(maxRow: self.maxRow, totalNumber: totalCount)

                            withAnimation {
                                self.main.toggle()
                            }
                        }
                    } else {
                        VStack {
                            Text("\(currentRow) x \(currentCol) = \(input.isEmpty ? "?" : input)").font(.largeTitle)
                            TextField("Enter your Answer", text: $input, onCommit: calc)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                                .keyboardType(.numbersAndPunctuation)
                                .transition(.scale)
                        }
                    }
                    Spacer()
                }
            }.navigationBarTitle("Multiple Fun")
            .alert(isPresented: $showingScore) {
                Alert(title: Text("Finish!!"), message: Text("Your score is " + String(score) + " /" + self.questions[self.questionIndex] ), dismissButton: .default(Text("Restart")) { self.startGame() })
            }
        }
    }

    func startGame() {
        maxRow = 1
        questionIndex = 3
        main = true
        showingMessage = false
        showingScore = false
        score = 0
        quiz = nil
        input = ""
        inc = 0
    }

    func calc() {
        if let answer = Int(input), answer == currentRow * currentCol {
            score += 1
        }
        guard let totalNumber = quiz?.questions.count else { return }
        if inc < totalNumber {
            inc += 1
        }
        input = ""
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
