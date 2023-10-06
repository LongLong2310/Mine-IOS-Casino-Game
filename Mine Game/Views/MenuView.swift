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
import AVFoundation

struct MenuView: View {
    var userManager: UserManager
    @State private var isLoggedIn = true
    @State var selectedDifficulty: Difficulty = .easy
    @State private var activeNavigationLink: NavigationLinkType?
    @State public var username: String
    @State public var password: String
    @State private var backgroundMusicPlayer: AVAudioPlayer? // Declare the audio player
    @State private var isDarkMode = true
    @State private var isSoundEnabled = true
    @State private var isMusicEnabled = true
    @State private var isContinue = true
    @State private var isGameProgress = false
    @State private var preselectedIndex: Int = 0
    
    @State var uiWidth = UIScreen.main.bounds.width
    @State var uiHeight = UIScreen.main.bounds.height

    enum NavigationLinkType {
        case playGame, leaderboard, howToPlay, gameSettings
    }

    var body: some View {
        if !isLoggedIn {
            SignUpLoginView(userManager: userManager)
        } else {
            ZStack {
                NavigationView {
                    VStack {
                        HStack {
                            Button {
                                isLoggedIn = false
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: uiWidth * 0.12, height: uiHeight * 0.07)
                                    .foregroundColor((isDarkMode ? .white : Color(hex: "#071d2a")))
                            }
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .padding(.leading)
                            Spacer()
                        }
                        .padding(.leading)
                        .padding(.top)
                        
                        Spacer()
                            .frame(height: 40)

                        Image("mines_login_signup")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: uiWidth * 0.5, height: uiHeight * 0.3)
                            .cornerRadius(50)
                            .padding(.all)

                        VStack {
                            VStack(spacing: 20) {
                                Spacer()
                                    .frame(height: uiHeight * 0.05)

                                if isGameProgress {
                                    Button(action: {
                                        isContinue = true // will not continue the game
                                        activeNavigationLink = .playGame
                                    }) {
                                        Text(LocalizedStringKey("Continue"))
                                            .padding(.all)
                                            .frame(width: uiWidth * 0.5, height: uiHeight * 0.07)
                                            .background(Color.green)
                                            .foregroundColor(.white)
                                            .bold()
                                            .cornerRadius(20)
                                    }
                                    .background(
                                        NavigationLink("", destination: GameView(userManager: userManager, selectedDifficulty: $selectedDifficulty, backgroundMusicPlayer: $backgroundMusicPlayer, isSoundEnabled: $isSoundEnabled, isMusicEnabled: $isMusicEnabled, isContinue: $isContinue, isInGameProgress: $isGameProgress, isDarkMode: $isDarkMode, username: $username, password: $password), tag: .playGame, selection: $activeNavigationLink)
                                            .opacity(0) // Hide the actual link
                                    )
                                }
                                
                                Button(action: {
                                    isContinue = false // will not continue the game
                                    activeNavigationLink = .playGame
                                }) {
                                    Text(LocalizedStringKey("Play Game"))
                                        .padding(.all)
                                        .frame(width: uiWidth * 0.5, height: uiHeight * 0.07)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .bold()
                                        .cornerRadius(20)
                                }
                                .background(
                                    NavigationLink("", destination: GameView(userManager: userManager, selectedDifficulty: $selectedDifficulty, backgroundMusicPlayer: $backgroundMusicPlayer, isSoundEnabled: $isSoundEnabled, isMusicEnabled: $isMusicEnabled, isContinue: $isContinue, isInGameProgress: $isGameProgress, isDarkMode: $isDarkMode, username: $username, password: $password), tag: .playGame, selection: $activeNavigationLink)
                                        .opacity(0) // Hide the actual link
                                )
                                

                                NavigationLink(destination: HowToPlayView(isDarkMode: $isDarkMode), tag: .howToPlay, selection: $activeNavigationLink) {
                                    Text(LocalizedStringKey("How To Play"))
                                        .padding(.all)
                                        .frame(width: uiWidth * 0.5, height: uiHeight * 0.07)
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .bold()
                                        .cornerRadius(20)
                                }
                            }

                            Spacer()

                            HStack() {
                                NavigationLink(destination: LeaderboardView(userManager: userManager, username: username, password: password, isDarkMode: $isDarkMode), tag: .leaderboard, selection: $activeNavigationLink) {
                                    Image(systemName: "trophy.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: uiWidth * 0.15, height: uiHeight * 0.07)
                                        .foregroundColor(.yellow)
                                        .padding(.trailing)
                                }
                                .padding(.bottom)

                                Spacer()

                                NavigationLink(destination: GameSettingsView(selectedDifficulty: $selectedDifficulty, preselectedIndex: $preselectedIndex, isDarkMode: $isDarkMode, isSoundEnabled: $isSoundEnabled, isMusicEnabled: $isMusicEnabled), tag: .gameSettings, selection: $activeNavigationLink) {
                                    Image(systemName: "gearshape.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: uiWidth * 0.15, height: uiHeight * 0.07)
                                        .foregroundColor(.gray)
                                        .padding(.leading)
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.leading)
                        .padding(.trailing)
                        Spacer()
                    }
                    .frame(width: uiWidth * 1, height: uiHeight * 0.9)
                    .background(isDarkMode ? Color(hex: "#071d2a") : .white)
                }
                .onAppear {
                    playBackgroundMusic(sound: "background-music", type: "mp3")
                    isGameProgressedBeyondInitialState() // Call the function when the view appears
                }
                .onChange(of: isMusicEnabled) { newValue in
                    if newValue {
                        playBackgroundMusic(sound: "background-music", type: "mp3")
                    } else {
                        stopBackgroundMusic()
                    }
                }
                .onChange(of: isGameProgress) { newValue in
                    if newValue {
                        isGameProgressedBeyondInitialState()
                    } else {
                        isGameProgressedBeyondInitialState()
                    }
                }
            }
        }
    }

    // Function to play the background music
    private func playBackgroundMusic(sound: String, type: String) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                backgroundMusicPlayer?.numberOfLoops = -1 // Loop indefinitely
                backgroundMusicPlayer?.play()
            } catch {
                print("ERROR: Could not find and play the background music file!")
            }
        }
    }

    // Function to stop the background music
    private func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
    
    func isGameProgressedBeyondInitialState() {
        let defaults = UserDefaults.standard
        var usernameString = userManager.loggedInUser?.username ?? ""
        var mineAmount = defaults.double(forKey: "mineAmount" + usernameString)
        if mineAmount > 0.0 {
            isGameProgress = true
        }
        else {
            isGameProgress = false
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(userManager: UserManager(), selectedDifficulty: .medium, username: "", password: "")
    }
}

