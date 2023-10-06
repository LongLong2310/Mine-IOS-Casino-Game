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
import AVFAudio

struct GameView: View {
    let rows = 5
    let columns = 5
    
    @State private var cells: [[CellType]] = Array(repeating: Array(repeating: .diamond, count: 5), count: 5)
    @State private var mineAmount: Double = 0
    @State private var betAmount: Double = 0
    @State private var profitRate: Double = 0
    @State private var profit: Double = 0
    @State public var userManager: UserManager
    @State private var balance: Double = 0
    @State private var isGameStarted = false
    @State private var isGameOver = false
    @State private var isGameWin = false
    @State private var isCashout = false
    @State private var replacedCells: Set<String> = []
    @State private var diamondCount: Int = 0
    @State private var totalGames: Int = 0
    @State private var totalGamesWin = 0
    @Binding var selectedDifficulty: Difficulty
    @Binding public var backgroundMusicPlayer: AVAudioPlayer? // Declare the audio player
    @Binding public var isSoundEnabled: Bool
    @Binding public var isMusicEnabled: Bool
    @Binding public var isContinue: Bool
    @Binding public var isInGameProgress: Bool
    @Binding public var isDarkMode: Bool
    
    @State private var isGotNewAchievements: Bool = false
    
    @State private var newAchievementName: String = ""
    
    @State private var countConsecutiveWinGame: Int = 0
    
    @State private var minBet: Double = 1
    
    @State private var minMine: Double = 0
    
    @Binding public var username: String
    @Binding public var password: String
    
    @State var uiWidth = UIScreen.main.bounds.width
    @State var uiHeight = UIScreen.main.bounds.height
    
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
                VStack {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack {
                            ForEach(0..<columns, id: \.self) { column in
                                let cellID = "\(row)-\(column)"
                                CellView(cell: $cells[row][column], cellId: cellID, isGameOver: $isGameOver, isGameStarted: $isGameStarted, replacedCells: $replacedCells, profitRate: $profitRate, profit: $profit, betAmount: $betAmount, balance: $balance, userManager: $userManager, diamondCount: $diamondCount,mineAmount: $mineAmount,isGameWin: $isGameWin, isCashout: $isCashout, totalGames: $totalGames, totalGamesWin: $totalGamesWin, isSoundEnabled: $isSoundEnabled, isGotNewAchievement: $isGotNewAchievements, newAchievementString: $newAchievementName, countConsecutiveWinGame: $countConsecutiveWinGame, row: row, column: column)
                                    .disabled(isGameOver)
                                    .disabled(isGameWin)
                                    .disabled(!isGameStarted)
                            }
                        }
                    }
                }
                .frame(width: uiWidth * 0.97, height: uiHeight * 0.45)
                .background(Color(hex: "#071824"))
                .padding(.leading)
                .padding(.trailing)
                
                VStack {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Bet Amount")
                                .foregroundColor(Color(hex: "#b1bad3"))
                                .fontWeight(.bold)
                            Spacer()
//                                .frame(width: uiWidth * 0.45)
                            Text(String(format: "%.2f", userManager.loggedInUser?.balance ?? 0) + " US$")
                                .foregroundColor(Color(hex: "#b1bad3"))
                                .fontWeight(.bold)
                        }
                        .padding(.leading, 35)
                        .padding(.trailing, 35)
                        
                        HStack(spacing: 0) {
                            TextField("Enter bet amount", text: Binding(
                                get: {
                                    var text: String
                                    if(betAmount == 0) {
                                        text = ""
                                    }
                                    else {
                                        text = String(Int(betAmount))
                                    }
                                    return text
                                },
                                set: { newValue in
                                    if newValue.isEmpty {
                                        betAmount = 0
                                    } else if let value = Double(newValue) {
                                        betAmount = value
                                    }
                                }
                            ))
                                .keyboardType(.decimalPad)
                                .padding(.vertical, 8)
                                .background(
                                    (isDarkMode ? Color(hex: "#071824") : Color.gray))
                                .frame(width: uiWidth * 0.64)
                                .foregroundColor(Color.white)
                                .padding(.top, 2)
                                .padding(.leading, 2)
                                .padding(.bottom, 2)
                            Button("1/2") {
                                betAmount /= 2
                            }
                            .frame(width: uiWidth * 0.13)
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            Button("2x") {
                                betAmount *= 2
                            }
                            .frame(width: uiWidth * 0.13)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        }
                        .background(Color(hex: "#2F4553"))
                        
                        HStack {
                            Text("Min bet is: " + String(Int(minBet)))
                                .foregroundColor(isDarkMode ? Color.white : Color.black)
                                .padding(.leading, 32)
                            
                            Spacer()
                        }
                        .padding(.bottom, 10)
                    }
                    
                    VStack(spacing: 10) {
                        HStack {
                            Text("Mines")
                                .foregroundColor(Color(hex: "#b1bad3"))
                                .fontWeight(.bold)
                            Spacer()
                                .frame(width: uiWidth * 0.75)
                        }
                        
                        HStack(spacing: 0) {
                            TextField("Enter mines amount", value: $mineAmount, formatter: NumberFormatter())
                                .keyboardType(.decimalPad)
                                .padding(.vertical, 8)
                                .background(isDarkMode ? Color(hex: "#071824") : Color.gray)
                                .frame(width: uiWidth * 0.9)
                                .foregroundColor(Color.white)
                                .padding(.all, 2)
                                .disabled(isGameStarted)
                        }
                        .background(Color(hex: "#2F4553"))
                        
                        HStack {
                            Text("Min mines is: " + String(Int(minMine)))
                                .foregroundColor(isDarkMode ? Color.white : Color.black)
                                .padding(.leading, 32)
                            Spacer()
                        }
                    }
                    
                    if(isGameStarted) {
                        HStack(spacing: 70) {
                            HStack {
                                Text("Total Profit:")
                                    .foregroundColor(Color(hex: "#b1bad3"))
                                    .fontWeight(.bold)
                                Text(String(format: "%.2f", profit))
                                    .foregroundColor(Color(hex: "#b1bad3"))
                                    .fontWeight(.bold)
                            }
                            
                            HStack {
                                Text("Profit Rate:")
                                    .foregroundColor(Color(hex: "#b1bad3"))
                                    .fontWeight(.bold)
                                Text(String(format: "%.2f", profitRate))
                                    .foregroundColor(Color(hex: "#b1bad3"))
                                    .fontWeight(.bold)
                            }
                        }
                        .padding(.top)
                    }
                    
                    ZStack {
                        Button {
                            isGameWin = true
                            isGameStarted = false
                            isCashout = true
                            balance += profit
                            userManager.loggedInUser?.balance += profit
                            mineAmount = 0
                            countConsecutiveWinGame += 1
                            totalGames += 1
                            totalGamesWin += 1
                            
                            if(isSoundEnabled) {
                                playSound(sound: "cashout", type: "mp3")
                            }
                            
                            if let loggedInUsername = userManager.loggedInUser?.username {
                                userManager.updateUserBalance(username: loggedInUsername, newBalance: balance)
                                
                                if let loggedInUserHighscore = userManager.loggedInUser?.highscore {
                                    if(loggedInUserHighscore < balance) {
                                        userManager.updateUserHighScore(username: loggedInUsername, newHighscore: balance)
                                    }
                                }
                                
                                if countConsecutiveWinGame == 5 {
                                    if var loggedInUserAchievements = userManager.loggedInUser?.achievements {
                                        let newAchievement = "Mine Sweeper"
                                        if !loggedInUserAchievements.contains(newAchievement) {
                                            newAchievementName = "Mine Sweeper"
                                            loggedInUserAchievements.append(newAchievement)
                                            userManager.updateUserAchievements(username: loggedInUsername, newAchievements: loggedInUserAchievements)
                                            isGotNewAchievements = true
                                            countConsecutiveWinGame = 0
                                        }
                                    }
                                }
                                
                            }
                            
                        } label: {
                            Text("Cashout")
                                .frame(width: uiWidth * 0.9, height: uiHeight * 0.065)
                        }
                        .fontWeight(.bold)
                        .frame(width: uiWidth * 0.9, height: uiHeight * 0.065)
                        .foregroundColor(Color.black)
                        .background(Color.green)
                        .cornerRadius(5)
                        .opacity(isMineAmountValid() ? 1 : 0)
                        .opacity(isBetAmountValid() ? 1 : 0)
                        .opacity(isSelectedDiamond() ? 1 : 0.5)
                        .disabled(!isSelectedDiamond())
                        
                        Button {
                            replacedCells = []
                            profit = 0
                            profitRate = 0
                            startGame()
                        } label:{
                            Text("Bet")
                                .frame(width: uiWidth * 0.9, height: uiHeight * 0.065)

                        }
                        .fontWeight(.bold)
                        .frame(width: uiWidth * 0.9, height: uiHeight * 0.065)
                        .foregroundColor(Color.black)
                        .background(Color.green)
                        .cornerRadius(5)
                        .opacity(isGameStarted ? 0 : 1)
//                        .opacity(isMineAmountValid() ? 1 : 0.5)
                        .opacity((isBetAmountValid() && isMineAmountValid()) ? 1 : 0.5)
                        .disabled(!(isBetAmountValid() && isMineAmountValid()))

                    }
                    .padding(.top, 5)
                }
                
            }
            .background(isDarkMode ? Color(hex: "#0f212e") : .white)
            .frame(height: .infinity, alignment: .top)
            .onAppear {
                balance = userManager.loggedInUser?.balance ?? 0
                totalGames = userManager.loggedInUser?.totalGames ?? 0
                totalGamesWin = userManager.loggedInUser?.winGames ?? 0
                minMine = getMinMineAmount()
            }

            .onChange(of: totalGames) { newTotalGames in
                if let loggedInUsername = userManager.loggedInUser?.username {
                    userManager.updateUserTotalGamesAndWinGames(username: loggedInUsername, newTotalGames: newTotalGames, newWinGames: totalGamesWin)
                }

                totalGames = newTotalGames
            }
            
            .onChange(of: totalGamesWin) { newTotalGamesWin in
                
                if let loggedInUsername = userManager.loggedInUser?.username {
                    userManager.updateUserTotalGamesAndWinGames(username: loggedInUsername, newTotalGames: totalGames, newWinGames: newTotalGamesWin)
                }
                totalGamesWin = newTotalGamesWin
            }
            
            .onChange(of: countConsecutiveWinGame) { newCountConsecutiveWinGame in
                minBet = getMinBetAmount()
            }
            
            if ((isGameOver || isGameWin ) && !isGotNewAchievements) {
                VStack {
                    Text(isGameOver ? "Game Over" : "You Win")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                    
                    if isGameWin {
                        VStack {
                            Text("You earn \(Double(profit))")
                                .font(.title)
                                .foregroundColor(.red)
                                .padding(.bottom, 20)
                            Text("Bet min has changed")
                                .foregroundColor(.red)
                                .padding(.bottom, 20)
                        }

                    }
                    
                    Button("Continue") {
                        replacedCells = []
                        profit = 0
                        profitRate = 0
                        isGameOver = false
                        isGameWin = false
//                        startGame()
                    }
                    .frame(width: uiWidth * 0.35, height: uiHeight * 0.06)
                    .background(Color.green)
                    .foregroundColor(.black)
                    .cornerRadius(5)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
            
            if isGotNewAchievements {
                VStack {
                    Text("You eanred new achievement")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                    
                    Text("\(newAchievementName)")
                        .font(.title)
                        .foregroundColor(.red)
                        .padding(.bottom, 20)
                    
                    Button("Continue") {
                        replacedCells = []
                        profit = 0
                        profitRate = 0
                        isGameOver = false
                        isGameWin = false
                        isGotNewAchievements = false
                        newAchievementName = ""
//                        startGame()
                    }
                    .frame(width: uiWidth * 0.35, height: uiHeight * 0.06)
                    .background(Color.green)
                    .foregroundColor(.black)
                    .cornerRadius(5)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
        }
        .onAppear {
            if (isContinue) {
                loadGameState(username: userManager.loggedInUser?.username ?? "") // Load the saved game state when the view appears
            }
            stopBackgroundMusic()
//            isInGameProgress = true
        }
        .onDisappear() {
            if mineAmount > 0 {
                isInGameProgress = true
            }
            else {
                isInGameProgress = false
            }

            if (isMusicEnabled) {
                playBackgroundMusic(sound: "background-music", type: "mp3")
            }
            saveGameState(username: userManager.loggedInUser?.username ?? "") // Save the game state when the view disappears
        }
    }
    
    public func userExists(users: [User], username: String, password: String) -> User? {
        if let matchedUser = users.first(where: { user in
            user.username == username && user.password == password
        }) {
            return matchedUser // Return the matched user
        } else {
            return nil // Return nil if no match is found
        }
    }
    
    // Function to save the cells array to UserDefaults
    func saveCellsToUserDefaults(username: String) {
        let cellsRawValues = cells.map { $0.map { cell in
            return cell == .mine ? "mine" : "diamond"
        }}
        UserDefaults.standard.set(cellsRawValues, forKey: "gameCells" + username)
    }
    
    //Load game state
    func loadGameState(username: String) {
        let defaults = UserDefaults.standard
        // Load the cells array from UserDefaults
        if let loadedCellsRawValues = UserDefaults.standard.array(forKey: "gameCells" + username) as? [[String]] {
            cells = loadedCellsRawValues.map { $0.map { cellRawValue in
                return cellRawValue == "mine" ? .mine : .diamond
            }}
        }
        mineAmount = defaults.double(forKey: "mineAmount" + username)
        betAmount = defaults.double(forKey: "betAmount" + username)
        profitRate = defaults.double(forKey: "profitRate" + username)
        profit = defaults.double(forKey: "profit" + username)
        balance = defaults.double(forKey: "balance" + username)
        isGameStarted = defaults.bool(forKey: "isGameStarted" + username)
        isGameOver = defaults.bool(forKey: "isGameOver" + username)
        isGameWin = defaults.bool(forKey: "isGameWin" + username)
        isCashout = defaults.bool(forKey: "isCashout" + username)
        if let loadedReplacedCells = defaults.array(forKey: "replacedCells" + username) as? [String] {
            replacedCells = Set(loadedReplacedCells)
        }
        diamondCount = defaults.integer(forKey: "diamondCount" + username)
        totalGames = defaults.integer(forKey: "totalGames" + username)
        totalGamesWin = defaults.integer(forKey: "totalGamesWin" + username)
    }

    
    //Save game state
    func saveGameState(username: String) {
        let defaults = UserDefaults.standard
//        defaults.set(cells, forKey: "gameCells")
        saveCellsToUserDefaults(username: username)
        defaults.set(mineAmount, forKey: "mineAmount" + username)
        defaults.set(betAmount, forKey: "betAmount" + username)
        defaults.set(profitRate, forKey: "profitRate" + username)
        defaults.set(profit, forKey: "profit" + username)
        defaults.set(balance, forKey: "balance" + username)
        defaults.set(isGameStarted, forKey: "isGameStarted" + username)
        defaults.set(isGameOver, forKey: "isGameOver" + username)
        defaults.set(isGameWin, forKey: "isGameWin" + username)
        defaults.set(isCashout, forKey: "isCashout" + username)
        defaults.set(Array(replacedCells), forKey: "replacedCells" + username)
        defaults.set(diamondCount, forKey: "diamondCount" + username)
        defaults.set(totalGames, forKey: "totalGames" + username)
        defaults.set(totalGamesWin, forKey: "totalGamesWin" + username)
    }

    
    // Function to play the background music
    public func playBackgroundMusic(sound: String, type: String) {
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
    public func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        backgroundMusicPlayer = nil
    }
    
    func startGame() {
        isGameStarted = true
        isGameOver = false
        isGameWin = false
        isCashout = false
        diamondCount = 0
        
        var mineCount = Int(mineAmount)
        profitRate = 1.03 + (mineAmount * 0.08)
        mineCount = min(mineCount, rows * columns - 1)
        
        var positions = [(Int, Int)]()
        for row in 0..<rows {
            for column in 0..<columns {
                positions.append((row, column))
            }
        }
        positions.shuffle()
        
        cells = Array(repeating: Array(repeating: .diamond, count: columns), count: rows)
        
        for i in 0..<mineCount {
            let (row, column) = positions[i]
            cells[row][column] = .mine
        }
    }
    
    func isMineAmountValid() -> Bool {
        switch selectedDifficulty {
        case .easy:
            return mineAmount >= 1 && mineAmount <= 24
        case .medium:
            return mineAmount >= 10 && mineAmount <= 24
        case .hard:
            return mineAmount >= 20 && mineAmount <= 24
        }
//        return true
    }
    
    func getMinMineAmount() -> Double {
        switch selectedDifficulty {
        case .easy:
            return 1.0
        case .medium:
            return 10.0
        case .hard:
            return 20.0
        }
//        return true
    }
    
    func isBetAmountValid() -> Bool {
        return betAmount >= minBet && betAmount <= balance
    }
    
    func getMinBetAmount() -> Double {
        switch countConsecutiveWinGame {
        case 1:
            return balance * 0.10 // 10% of the balance
        case 2:
            return balance * 0.20 // 20% of the balance
        case 3:
            return balance * 0.30 // 30% of the balance
        case 4:
            return balance * 0.40 // 40% of the balance
        case 5:
            return balance * 0.50 // 50% of the balance
        default:
            return 0.0 // Default value when countConsecutiveWinGame is not in the specified cases
        }
    }

    
    func isSelectedDiamond() -> Bool {
        if(diamondCount == 0) {
            return false
        }
        else {
            return true
        }
    }
}

enum CellType {
    case diamond, mine
}

struct CellView: View {
    @Binding var cell: CellType
    var cellId: String
    @Binding var isGameOver: Bool
    @Binding var isGameStarted: Bool
    @Binding var replacedCells: Set<String>
    @Binding var profitRate: Double
    @Binding var profit: Double
    @Binding var betAmount: Double
    @Binding var balance: Double
    @Binding var userManager: UserManager
    @Binding var diamondCount: Int
    @Binding var mineAmount: Double
    @Binding var isGameWin: Bool
    @Binding var isCashout: Bool
    @Binding var totalGames: Int
    @Binding var totalGamesWin: Int
    @Binding var isSoundEnabled: Bool
    @Binding var isGotNewAchievement: Bool
    @Binding var newAchievementString: String
    @Binding var countConsecutiveWinGame: Int
    
    @State var uiWidth = UIScreen.main.bounds.width
    @State var uiHeight = UIScreen.main.bounds.height
    
    let row: Int
    let column: Int
    
    var body: some View {
        Button(action: {
            // Handle cell tap based on game state
            
            if !isGameOver && !isGameWin{
                if replacedCells.contains(cellId) {

                } else {
                    if (cell == .mine) {
                        countConsecutiveWinGame = 0
                        if(isSoundEnabled) {
                            playSound(sound: "bomb", type: "mp3")
                        }
                        mineAmount = 0
                        isGameOver = true
                        isGameStarted = false
                        balance -= betAmount
                        userManager.loggedInUser?.balance -= betAmount
                        if let loggedInUsername = userManager.loggedInUser?.username {
                            // Update the balance for the logged-in user
                            userManager.updateUserBalance(username: loggedInUsername, newBalance: balance)
                            totalGames += 1
                            
                            userManager.updateUserTotalGamesAndWinGames(username: loggedInUsername, newTotalGames: totalGames, newWinGames: totalGamesWin)
                        }
                    }
                    else {
                        //Sound Effect
                        if(isSoundEnabled) {
                            playSound(sound: "diamond", type: "mp3")
                        }
                        diamondCount += 1
                        profit += betAmount * profitRate - betAmount
                        profitRate += 0.06
                        let diamondToWin = 25 - Int(mineAmount)
                        
                        if (diamondCount == diamondToWin) {
                            countConsecutiveWinGame += 1
                            totalGamesWin += 1
                            totalGames += 1
                            if (isSoundEnabled) {
                                playSound(sound: "cashout", type: "mp3")
                            }
                            mineAmount = 0
                            isGameWin = true
                            isGameStarted = false
//                            isCashout = true
                            balance += profit
                            userManager.loggedInUser?.balance += profit
                            if let loggedInUsername = userManager.loggedInUser?.username {
                                userManager.updateUserBalance(username: loggedInUsername, newBalance: balance)

                                if let loggedInUserHighscore = userManager.loggedInUser?.highscore {
                                    if(loggedInUserHighscore < balance) {
                                        userManager.updateUserHighScore(username: loggedInUsername, newHighscore: balance)
                                    }
                                }
                                
                                //Add achievements for Diamond Collector
                                if diamondCount == 1 {
                                    if var loggedInUserAchievements = userManager.loggedInUser?.achievements {
                                        let newAchievement = "Diamond Collector"
                                        if !loggedInUserAchievements.contains(newAchievement) {
                                            newAchievementString = "Diamond Collector"
                                            loggedInUserAchievements.append(newAchievement)
                                            userManager.updateUserAchievements(username: loggedInUsername, newAchievements: loggedInUserAchievements)
                                            isGotNewAchievement = true
                                            
                                        }
                                    }
                                }
                                
                                if countConsecutiveWinGame == 5 {
                                    if var loggedInUserAchievements = userManager.loggedInUser?.achievements {
                                        let newAchievement = "Mine Sweeper"
                                        if !loggedInUserAchievements.contains(newAchievement) {
                                            newAchievementString = "Mine Sweeper"
                                            loggedInUserAchievements.append(newAchievement)
                                            userManager.updateUserAchievements(username: loggedInUsername, newAchievements: loggedInUserAchievements)
                                            isGotNewAchievement = true
                                            countConsecutiveWinGame = 0
                                        }
                                    }
                                }
                            }
                        }
                    }
                    replacedCells.insert(cellId)
                }
            }
        }) {
            if replacedCells.contains(cellId) {
                Image( cell == .mine ? "bomb-in-game" : "diamond-in-game")
                    .resizable()
                    .frame(width: uiWidth * 0.165, height: uiWidth * 0.165)
                    .foregroundColor(Color.blue)
                    .transition(.scale)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: uiWidth * 0.165, height: uiWidth * 0.165)
                    .foregroundColor(Color(hex: "#2F4553"))
                    .overlay(
                        Text("")
                            .foregroundColor(.white)
                    )
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 3)
//                    .padding()
            }
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(
            userManager: UserManager(),
            selectedDifficulty: .constant(.easy),
            backgroundMusicPlayer: .constant(nil), isSoundEnabled: .constant(true), isMusicEnabled: .constant(true), isContinue: .constant(false), isInGameProgress: .constant(true), isDarkMode: .constant(false), username: .constant(""), password: .constant("")
        )
    }
}


