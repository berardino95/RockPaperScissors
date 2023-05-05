//
//  ContentView.swift
//  RockPaperScrissors
//
//  Created by CHIARELLO Berardino - ADECCO on 25/04/23.
//

import SwiftUI

struct ContentView: View {
    
    let moves = ["🪨", "📄", "✂️"]
    @State private var userChoice : String = ""
    @State private var appChoice : String = ""
    
    @State private var alertText : String = ""
    @State private var userScore: Int = 0
    @State private var alertIsShowed : Bool = false
    @State private var endAlertIsShowed : Bool = false
    
    @State private var appScore: Int = 0
    @State private var round: Int = 1
    var remainingCoin: Int { 8 - round + 1 }
    
    
    var body: some View {
        VStack (spacing:0){
            Spacer()
            
            Text("Rocks paper\nscissors")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            HStack{
                Spacer()
                VStack{
                    Text("Your choice")
                    Text(userChoice)
                        .emoji()
                        .scaleEffect(userChoice.isEmpty ? 1.2 : 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.green, lineWidth: 2)
                        )
                        .animation(.easeOut, value: userChoice)
                }
                Spacer()
                VStack{
                    Text("Pc choice")
                    Text(appChoice)
                        .emoji()
                        .scaleEffect(userChoice.isEmpty ? 1.2 : 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.green, lineWidth: 2)
                        )
                        .animation(.easeOut, value: userChoice)
                }
                
                Spacer()
            }
            
            Spacer ()
            
            VStack{
                Text("Select your move")
                HStack{
                    ForEach(moves, id: \.self){ move in
                        Button(move){
                            check(move)
                        }
                        .buttonStyle(moveButton())
                        .scaleEffect(!userChoice.isEmpty && userChoice == move ? 1.1 : 1)
                        .scaleEffect(!userChoice.isEmpty && userChoice != move ? 0.9 : 1)
                        .opacity(!userChoice.isEmpty && userChoice != move ? 0.8 : 1)
                        .animation(.easeOut, value: userChoice)
                    }
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.green, lineWidth: 2)
                )
            }
            
            Spacer()
            
            VStack(spacing: 10){
                Text("Your Score: \(userScore)")
                Text("Pc Score: \(appScore)")
            }
            
            Spacer()
            
            Text("Remaining coin: \(remainingCoin)")
                .font(.caption)
        }
        .padding()
        
        .alert(alertText, isPresented: $alertIsShowed) {
            Button("ok", role: .cancel, action: nextRound)
        } message: {
            Text("Your score: \(userScore)\nPc Score: \(appScore)")
        }
        
        .alert(alertText, isPresented: $endAlertIsShowed) {
            Button("Restart", role: .cancel, action: restart)
        } message: {
            Text("Final score \n You: \(userScore)  Pc: \(appScore)")
        }
        
    }
    
    func restart() {
        userChoice = ""
        appChoice = ""
        userScore = 0
        appScore = 0
        round = 1
    }
    
    func nextRound() {
        userChoice = ""
        appChoice = ""
    }
    
    func check(_ move: String){
        appChoice = moves.randomElement()!
        userChoice = move
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            if round == 8 {
                endAlertIsShowed = true
            } else {
                alertIsShowed = true
            }
            switch (userChoice, appChoice) {
            case ("📄","🪨") :
                alertText = "You won"
                userScore += 1
                round += 1
            case ("✂️","📄") :
                alertText = "You won"
                userScore += 1
                round += 1
            case ("🪨","✂️") :
                alertText = "You won"
                userScore += 1
                round += 1
            case ("🪨","📄") :
                alertText = "You lose"
                appScore += 1
                round += 1
            case ("📄","✂️") :
                alertText = "You lose"
                appScore += 1
                round += 1
            case ("✂️","🪨") :
                alertText = "You lose"
                appScore += 1
                round += 1
            default:
                alertText = "Draw"
                round += 1
            }
        }
    }
}


//custom button style
struct moveButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 30))
            .frame(width: 60, height: 60)
            .background(Color(.systemGray4))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


// Custom Text modifier for bigger icon
struct Emoji : ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 90))
            .frame(width: 140, height: 140)
    }
}

extension View {
    func emoji() -> some View {
        modifier(Emoji())
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
