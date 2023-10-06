/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Pham Trinh Hoang Long
  ID: s3879366
  Created  date: 23/08/2023
  Last modified: 06/09/2023
  Acknowledgement:
*/

import SwiftUI

struct HowToPlayView: View {
    @Binding public var isDarkMode: Bool
    
    var body: some View {
        ZStack {
            if isDarkMode {
                Color(hex: "#071d2a")
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.white
                    .edgesIgnoringSafeArea(.all)
            }
            
            ScrollView {
                VStack {
                    Text(LocalizedStringKey("How To Play"))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        .padding(.bottom, 20)
                    
                    Text(LocalizedStringKey("Welcome to the Mine Game!"))
                        .font(.headline)
                        .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        .padding(.bottom, 10)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(LocalizedStringKey("Objective:"))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        Text(LocalizedStringKey("Your goal is to find all the diamonds hidden on the grid while avoiding hitting any mines."))
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                    }
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(LocalizedStringKey("Game Rules:"))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        Text(LocalizedStringKey("1. Enter your bet amount and the number of mines you want to play with."))
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        Text(LocalizedStringKey("2. Tap on the cells to reveal their contents."))
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        Text(LocalizedStringKey("3. If you reveal a diamond, you'll earn a profit based on your bet amount and the profit rate."))
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        Text(LocalizedStringKey("4. If you reveal a mine, the game is over, and you'll lose your bet amount."))
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        Text(LocalizedStringKey("5. The profit rate increases after each successful diamond reveal."))
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        Text(LocalizedStringKey("6. If you reveal all diamonds without hitting a mine, you win the game and earn the profit."))
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                    }
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(LocalizedStringKey("Tips:"))
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        Text(LocalizedStringKey("1. Start with a smaller bet amount and gradually increase it as you get comfortable with the game."))
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                        Text(LocalizedStringKey("2. Be strategic in your choices to maximize your profits and minimize the risks."))
                            .foregroundColor(isDarkMode ? Color(hex: "#d5dceb") : .black)
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView(isDarkMode: .constant(false))
    }
}

