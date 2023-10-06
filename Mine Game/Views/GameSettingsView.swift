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

struct GameSettingsView: View {
    @Environment(\.locale) private var locale: Locale

    @Binding var selectedDifficulty: Difficulty
    @State private var showDescription = false
    @Binding public var preselectedIndex: Int
    @Binding public var isDarkMode: Bool
    @Binding public var isSoundEnabled: Bool
    @Binding public var isMusicEnabled: Bool
    @State private var selectedLanguageIndex = 0 // Track the selected language index
    @State private var isDropdownOpen = false // Track dropdown visibility
    
    // Define a key for localized strings
    @State private var gameSettingsTitle = "Game Settings"
    @State private var darkModeTitle = "Dark Mode"
    @State private var soundTitle = "Sound"
    @State private var musicTitle = "Music"
    @State private var languageTitle = "Language:"
    
    @State private var easyDescription = ""
    @State private var mediumDescription = ""
    @State private var hardDescription = ""
    
    @State var uiHeight = UIScreen.main.bounds.height
    
    @StateObject private var languageManager = LanguageManager.shared
    
    // Create an array of available languages
    @State private var availableLanguages = [
        Language(id: 0, name: "English"),
        Language(id: 1, name: "Spanish"),
        Language(id: 2, name: "Vietnamese")
    ]
    
    var body: some View {
        ZStack {
            if isDarkMode {
                Color(hex: "#071d2a")
                    .edgesIgnoringSafeArea(.all)
            } else {
                Color.white
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                Text(LocalizedStringKey(gameSettingsTitle)) // Use the localized string
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(isDarkMode ? .white : .black) // Set text color conditionally
//                    .padding(.top)
                    .frame(height: uiHeight * 0.2)
                
                Spacer()
                
                VStack(spacing: 40) {
                    Toggle(isOn: $isDarkMode) {
                        Label(LocalizedStringKey(darkModeTitle), systemImage: "moon.fill")
                            .font(.headline)
                            .foregroundColor(isDarkMode ? .white : .black) // Set text color conditionally
                    }
                    .padding(.all)
                    
                    Toggle(isOn: $isSoundEnabled) {
                        Label(LocalizedStringKey(soundTitle), systemImage: "speaker.fill")
                            .font(.headline)
                            .foregroundColor(isDarkMode ? .white : .black) // Set text color conditionally
                    }
                    .padding(.all)

                    Toggle(isOn: $isMusicEnabled) {
                        Label(LocalizedStringKey(musicTitle), systemImage: "music.note")
                            .font(.headline)
                            .foregroundColor(isDarkMode ? .white : .black) // Set text color conditionally
                    }
                    .padding(.all)
                    
                    HStack {
                        Text(LocalizedStringKey(languageTitle))
                            .foregroundColor(isDarkMode ? .white : .black) // Set text color conditionally
                            .font(.headline)
                        Spacer()
                        
                        // Use a Picker to select the language
                        Picker(selection: $languageManager.selectedLanguageIndex, label: Text("")) {
                            ForEach(0..<availableLanguages.count, id: \.self) { index in
                                Text(availableLanguages[index].name)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(isDarkMode ? .white : .black) // Set text color conditionally
                    }
                    .padding(.all)
                    
                    CustomSegmentedControl(preselectedIndex: $preselectedIndex, isDarkMode: $isDarkMode, options: Difficulty.allCases.map { $0.rawValue })
                        .padding(.top)
                        .padding(.leading)
                        .padding(.trailing)
                    
                    Text(LocalizedStringKey(Difficulty.allCases[preselectedIndex].description))
                        .padding(.bottom)
                        .padding(.leading)
                        .padding(.trailing)
                        .multilineTextAlignment(.center)
                        .foregroundColor(isDarkMode ? .white : .black) // Set text color conditionally
                        .frame(height: uiHeight * 0.1)
                }
                .padding(.top)
                
                Spacer()
            }
            .padding()
        }
        .onChange(of: languageManager.selectedLanguageIndex) { newIndex in
            // Change the app's language dynamically
            let newLanguage = availableLanguages[newIndex].name
            UserDefaults.standard.set([newLanguage], forKey: "AppleLanguages") // Update app language
            UserDefaults.standard.synchronize()
            
        }
        
        .onChange(of: preselectedIndex) { newIndex in
            selectedDifficulty = Difficulty.allCases[newIndex]
        }
    }

    // Define a dummy destination for navigation
    private var navigationDestination: some View {
        EmptyView()
    }
}

struct Language: Identifiable {
    var id: Int
    var name: String
}

struct CustomDropdownView: View {
    var options: [String]
    @Binding var selectedIndex: Int
    @Binding var isDropdownOpen: Bool
    @Binding var isDarkMode: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                Button(action: {
                    selectedIndex = index
                    isDropdownOpen.toggle()
                }) {
                    Text(options[index])
                        .foregroundColor(isDarkMode ? .white : .black) // Set text color conditionally
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .font(.headline)
                }
                .background(Color(hex: "#3d5564"))
            }
        }
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
    }
}

struct CustomSegmentedControl: View {
    @Binding var preselectedIndex: Int
    @Binding var isDarkMode: Bool
    var options: [String]
    let color = Color(.green)
    @State var uiHeight = UIScreen.main.bounds.height
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.2))
                    Rectangle()
                        .fill(color)
                        .cornerRadius(20)
                        .padding(2)
                        .opacity(preselectedIndex == index ? 1 : 0.01)
                        .onTapGesture {
                            withAnimation(.interactiveSpring()) {
                                preselectedIndex = index
                            }
                        }
                }
                .overlay(
                    Text(options[index])
                        .foregroundColor(isDarkMode ? .white : .black) // Set text color conditionally
                )
            }
        }
        .frame(height: uiHeight * 0.05 )
        .cornerRadius(20)
    }
}

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    
    var description: String {
        switch self {
        case .easy:
            return "In Easy mode, user can choose from 0 to 25 mines and higher winning chances."
        case .medium:
            return "Medium mode offers a balanced challenge with a moderate number of mines. (from 10 to 25 mines)"
        case .hard:
            return "Hard mode is for experienced players, with more mines and higher risks. (from 20 - 25 mines)"
        }
    }
}

struct GameSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GameSettingsView(
            selectedDifficulty: .constant(.medium), preselectedIndex: .constant(0),
            isDarkMode: .constant(true),
            isSoundEnabled: .constant(true),
            isMusicEnabled: .constant(true)
        )
    }
}

