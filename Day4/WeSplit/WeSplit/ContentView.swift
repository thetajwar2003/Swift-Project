//
//  ContentView.swift
//  WeSplit
//
//  Created by Tajwar Rahman on 12/22/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numOfPeople = ""
    @State private var tipPercentage = 2
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var total: Double{
        let tipSelection = Double(tipPercentages[tipPercentage])/100
        let orderAmount = Double(checkAmount) ?? 0
        
        return orderAmount * (1 + tipSelection)
    }
    
    var totalPerPerson: Double{
        // calculate total per person
        let peopleCount = Double(numOfPeople) ?? 1 // we add 1 so there isn't 'NA' in the per person field
        let tipSelection = Double(tipPercentages[tipPercentage])/100
        let orderAmount = Double(checkAmount) ?? 0
        
        let grandTotal = orderAmount * (1 + tipSelection)
        let perPerson = grandTotal / peopleCount
        
        return perPerson
    }
    
    var body: some View {
        NavigationView{
            Form{
                // section to enter amount and choose number of people
                Section{
                    // textfield for bill amount
                    TextField("Amount: ", text: $checkAmount).keyboardType(.decimalPad)
                    // textfield for number of people
                    TextField("Number of People", text: $numOfPeople).keyboardType(.numberPad)
                }
                
                // section to select tip %
                Section(header: Text("Tip Percentage")){
                    Picker("Tip percentage", selection: $tipPercentage){
                        ForEach(0 ..< tipPercentages.count){
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                
                // section for total bill
                Section(header: Text("Total Bill Cost")){
                    Text("$\(total, specifier: "%.2f")").foregroundColor(tipPercentages[tipPercentage] == 0 ? .red : .black)
                }
                
                //section for amount per person
                Section(header: Text("Amount Per Person")){
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
            }.navigationBarTitle("WeSplit")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
