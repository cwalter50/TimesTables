//
//  ContentView.swift
//  TimesTables
//
//  Created by Christopher Walter on 4/24/20.
//  Copyright © 2020 Christopher Walter. All rights reserved.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.blue)
//            .padding()
//            .background(Color.orange)
//            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}

struct PlayButton: View {
    
    @State var name = ""
    var body: some View {
        Text("\(name)")
//            .padding()
//            .frame(maxWidth: .infinity)
//            .foregroundColor(.white)
//            .background(Color.blue)
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color.blue, lineWidth: 4)
//            )
        .fontWeight(.bold)
            .font(.headline)
        .foregroundColor(.blue)
            
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 5)
            
        )
        

            
    }
}

struct ContentView: View {
    
    @State var inGameMode = false
    @State var minimum = 5
    @State var maximum = 8
    @State var numQuestions = "1"
    @State var num1 = 2
    @State var num2 = 3
    
    @State var answer = ""
    var questionAmounts = ["5", "10", "20", "All"]
    @State var questions: [Question] = []
    
    @State var questionCounter = 0
    
    func createQuestions()
    {
        questions.removeAll()
        for num1 in minimum...maximum
        {
            for num2 in minimum ... maximum
            {
                let newQuest = Question(num1: num1, num2: num2)
                questions.append(newQuest)
            }
        }
        questions.shuffle()
    }
    
    func loadQuestion()
    {
        let currentQuestion = questions[questionCounter % questions.count] // make sure we lap back around if there are not enough questions
        num1 = currentQuestion.num1
        num2 = currentQuestion.num2
        questionCounter += 1
//        answer = "\(num1 * num2)"
    }
    
    var body: some View {
        NavigationView {
            VStack{
                if !inGameMode {
                    Group {
                          Text("What times tables would you like to practice?")
                          Stepper("Min: \(minimum)", value: $minimum, in: 1...maximum)
                          Stepper("Max: \(maximum)", value: $maximum, in: minimum...12)
                          HStack {
                              Text("How many questions?")
                              Picker("QuestionCount", selection: $numQuestions) {
                                  ForEach(0..<self.questionAmounts.count) {
                                      Text("\(self.questionAmounts[$0])")
                                  }
                              }
                              .pickerStyle(SegmentedPickerStyle())
                          }
        
                      }.animation(.easeInOut)
                }
//                Spacer()
                if inGameMode {
                    Group {
                        HStack {
                            Button(action: {
                                // todo
                            }) {
                                PlayButton(name: "\(num1)")
                            }
                            Text(" x ")
                            Button(action: {
                                // todo
                            }) {
                                PlayButton(name: "\(num2)")
                            }

                        }
                        TextField("Answer", text: $answer)
                        .padding(10)
                        .font(Font.system(size: 15, weight: .medium, design: .serif))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                            .keyboardType(.decimalPad)
                        Spacer()
                        Text("Score: 3/4")
                        Spacer()
                    }
                    .animation(.easeInOut)
                }
                Spacer()
            }
            .navigationBarTitle("Times Tables")
            .padding(.leading)
            .padding(.trailing)
            .navigationBarItems(trailing:
                Button(inGameMode ? "Settings" : "Play") {
                    self.inGameMode.toggle()
                    // create Questions
                    self.createQuestions()
                    self.loadQuestion()
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
