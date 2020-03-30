//
//  ContentView.swift
//  todoist.gant
//
//  Created by Aleksey Groylov on 31.03.2020.
//  Copyright © 2020 Aleksey Groylov. All rights reserved.
//

import SwiftUI


/// struct for print color slider in view
struct ColorSlider: View {
    @Binding var value: Double
    var textColor: Color
    
    var body: some View {
        HStack {
            Text("0").foregroundColor(textColor)
            Slider(value: $value)
            Text("255").foregroundColor(textColor)
        }
        .padding(.horizontal)
    }
}

struct ContentView: View {
    
    let rTarget = Double.random(in: 0..<1)
    let gTarget = Double.random(in: 0..<1)
    let bTarget = Double.random(in: 0..<1)
    
    @State var rGuess: Double
    @State var gGuess: Double
    @State var bGuess: Double
    @State var showAlert = false
    
    
    /// <#Description#>
    /// - Returns: <#description#>
    func computeScore() -> Int {
      let rDiff = rGuess - rTarget
      let gDiff = gGuess - gTarget
      let bDiff = bGuess - bTarget
      let diff = sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff)
      return Int((1.0 - diff) * 100.0 + 0.5)
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Rectangle()
                    .foregroundColor(Color(red: rTarget, green: gTarget, blue: bTarget, opacity: 1.0))
                    HStack {
                        Text("Target Color Block")
                    }
                }
                VStack {
                    Rectangle()
                    .foregroundColor(Color(red: rGuess, green: gGuess, blue: bGuess, opacity: 1.0))
                    HStack {
                        Text("R: \(Int(rGuess * 255.0))").foregroundColor(.red)
                        Text("G: \(Int(gGuess * 255.0))").foregroundColor(.green)
                        Text("B: \(Int(bGuess * 255.0))").foregroundColor(.blue)
                    }
                }
            }
                
            HStack {
                Button(action: {self.showAlert = true}, label: {Text("Check All")}).alert(isPresented: $showAlert) {
                  Alert(title: Text("Your Score"), message: Text("\(computeScore())"))
                }
            }
            HStack {
                VStack {
                    ColorSlider(value: $rGuess,textColor: .red)
                    ColorSlider(value: $gGuess,textColor: .green)
                    ColorSlider(value: $bGuess,textColor: .blue)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(rGuess: 0.5, gGuess: 0.5, bGuess: 0.5)
    }
}


