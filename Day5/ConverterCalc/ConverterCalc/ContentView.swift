//
//  ContentView.swift
//  ConverterCalc
//
//  Created by Tajwar Rahman on 12/24/20.
//  Copyright © 2020 Tajwar Rahman. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var temp = "" // variable that the user inputs
    @State private var fromIndex = 0 // converting from Farenheit
    @State private var toIndex = 1 // converting to celcius in the beginning
    let temps = ["Farenheit", "Celcius", "Kelvin"] // list of temp units
    
    // nested switch cases which determines what the output should be based on current unit
    var convertedTemp: Measurement<UnitTemperature>{
        let finalTemp = Double(temp) ?? 0
        switch fromIndex {
        // initial unit is farenheit
        case 0:
            let far = Measurement(value: finalTemp, unit: UnitTemperature.fahrenheit)
            switch toIndex {
            // convert farenheit to celcius
            case 1:
                return far.converted(to: UnitTemperature.celsius)
            // convert farenheit to kelvin
            case 2:
                return far.converted(to: UnitTemperature.kelvin)
            // return farenheit if farenheit is chosen
            default:
                return far
            }
        // initial unit is celcius
        case 1:
            let cel = Measurement(value: finalTemp, unit: UnitTemperature.celsius)
            switch toIndex {
            // convert celcius to farenheit
            case 0:
                return cel.converted(to: UnitTemperature.fahrenheit)
            // convert celcius to kelvin
            case 2:
                return cel.converted(to: UnitTemperature.kelvin)
            // return celcius if celcius is chosen
            default:
                return cel
            }
        // initial unit is kelvin
        case 2:
            let kel = Measurement(value: finalTemp, unit: UnitTemperature.kelvin)
            switch toIndex {
            // convert kelvin to farenheit
            case 0:
                return kel.converted(to: UnitTemperature.fahrenheit)
            // convert kelvin to celcius
            case 1:
                return kel.converted(to: UnitTemperature.celsius)
            // return kelvin if kelvin is chosen
            default:
                return kel
            }
        // should never reach here so logging error if it ever does
        default:
            print("error")
        }
        // should never reach here but returning 0 if choice isn't one of the above
        return Measurement(value: 0.0, unit: UnitTemperature.fahrenheit)
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Temperature")){
                    Picker("From:", selection: $fromIndex){
                        ForEach(0 ..< temps.count){
                            Text("\(self.temps[$0])") // lists out the different units
                        }
                    }
                    // allows the user to enter the temoerature they want to convert using the decimal pad
                    TextField("Enter Temperature: 0", text: $temp).keyboardType(.decimalPad)
                    
                    Picker("To:", selection: $toIndex){
                        ForEach(0 ..< temps.count){
                            Text("\(self.temps[$0])") // lists out the different units
                        }
                    }
                    Text("\(convertedTemp.value, specifier: "%.2f")") // shows the converted value
                }
            }.navigationBarTitle("ConverterCalc")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
