//
//  ContentView.swift
//  BetterRest
//
//  Created by Tajwar Rahman on 12/27/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    var body: some View {
        NavigationView{
            Form{
                // this section is a picker showing what time the user wants to wake up
                Section{
                    Text("When do you want to wake up?").font(.headline)
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                }
                
               // this section is
               Section{
                    Text("Enter desired amount of sleep").font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25){
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }.accessibility(value: Text("\(sleepAmount) hours of sleep"))
                }
                

                Section{
                    Text("Daily cofee intake").font(.headline)
                    Picker("How many cups", selection: $coffeeAmount){
                        ForEach(1..<21){
                            Text($0 > 1 ? "\($0) cups" : "\($0) cup")
                        }
                    }
                }
                
                Section{
                    Text(calculateBedTime()).font(.largeTitle).fontWeight(.semibold)
                }
            }
            .navigationBarTitle("BetterRest")
        }
    }
    
    // makes the default picker time 7:00 AM
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    // a func that uses the ml model we created to predict when the user should sleep based on when they want to wake up, how many hours of sleep they want, and how many cups of coffee they've had
    func calculateBedTime() -> String{
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 3600
        let minute = (components.minute ?? 0) * 60
        
        var message = ""
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            message = "Your ideal bed time is: " + formatter.string(from: sleepTime)
        } catch{
            message = "There was a problem calculating yoru bedtime."
        }
        return message
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
