//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Alison Gorman on 12/23/20.
//

import SwiftUI

struct FlagImage: View {
    var country: String

    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var animateCorrect = false
    @State private var animateWrong = false
    @State private var wrongAnswer = 4
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    
    func spin(_ number: Int) -> Bool {
            return number == correctAnswer
        }
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
            
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        if number == correctAnswer {
                            withAnimation(.default){
                                animateCorrect = true
                                }
                            }
                        else {
                            withAnimation(.default){
                                animateWrong = true
                                wrongAnswer = number
                            }
                        }
                        self.flagTapped(number)

                    }) {
                        FlagImage(country: countries[number])
                    }
                    .rotation3DEffect(.degrees( number == correctAnswer && animateCorrect ? 360.0 : 0.0), axis: (x: 0, y: 0, z: 1))
                    .opacity(number != correctAnswer && animateCorrect ? 0.25 : 1)
                    .overlay(number == wrongAnswer && animateWrong ? Capsule().fill(Color.red) : nil)
                }
                
                Text("Score: \(score)")
                    .font(.largeTitle)
                Spacer()
                }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text("Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            }
            }
        }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])"
            score -= 1
        }
        showingScore = true
    }
    
    func askQuestion() {
        animateCorrect = false
        animateWrong = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        wrongAnswer = 4
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
