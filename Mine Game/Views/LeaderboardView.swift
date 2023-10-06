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

struct LeaderboardView: View {
    var userManager: UserManager
    @State var username: String
    @State var password: String
    
    @State var achievementBadges: [AchievementBadge] = [
        AchievementBadge(name: "Diamond Collector", imageName: "no-achievement"),
        AchievementBadge(name: "Mine Sweeper", imageName: "no-achievement"),
    ]
    
    @State var userAchievements = [String]()
    
    @Binding public var isDarkMode: Bool
    
    @State var user = User(
        username: "DefaultUsername",
        password: "DefaultPassword",
        balance: 0.0,
        highscore: 0.0,
        achievements: [],
        totalGames: 0,
        winGames: 0
    )
    
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
                Text(LocalizedStringKey("Leaderboard"))
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(isDarkMode ? .white : .black)
                
                List {
                    ForEach(userManager.users.sorted(by: { $0.highscore > $1.highscore })) { user in
                        HStack {
                            Text(user.username)
                                .font(.headline)
                                .foregroundColor(isDarkMode ? .black : .white)
                            Spacer()
                            Text(String(format: "%.2f $", user.highscore))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .listRowBackground(isDarkMode ? .white : Color(hex: "#071d2a")) // Set the background color for each row

                    }

                }
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)) // Add padding around the List
                .background(Color(.white)) // Set the background color of the entire List
                .cornerRadius(15) // Optional: Add corner radius to the List
                .frame(width: uiWidth * 0.8, height: uiHeight * 0.37)
                .listStyle(PlainListStyle())
                
                Divider()
                
                Text(LocalizedStringKey("Achievement Badges"))
                    .font(.title)
                    .foregroundColor(isDarkMode ? .white : .black)
                    .padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(achievementBadges, id: \.name) { badge in
                            AchievementBadgeView(badge: badge)
                        }
                    }
                    .padding(.top)
                    .padding(.bottom)
                }
                .background(isDarkMode ? .white : Color(hex: "#071d2a"))
                .cornerRadius(15)
                
                Divider()
                
                Text(LocalizedStringKey("Gameplay Statistics"))
                    .font(.title)
                    .foregroundColor(isDarkMode ? .white : .black)
                
                Spacer()
                
                VStack {
                    Text(LocalizedStringKey("Total Games Played: \(getTotalGames())"))
                        .padding(.bottom, 5)
                        .foregroundColor(isDarkMode ? .white : .black)
                    Text(LocalizedStringKey("Win Percentage: \(calculateWinPercentage())%"))
                        .foregroundColor(isDarkMode ? .white : .black)
                        .padding(.bottom)
                }
            }
            .padding()
            .onAppear {
                let users = userManager.loadUsers()
                if let userUpdated = userExists(users: users, username: username, password: password) {
                    user = userUpdated
                } else {
                    // Handle the case where the user does not exist
                    // You can show an error message or take appropriate action
                }
                
                userAchievements = user.achievements

                var updatedBadges = achievementBadges  // Create a copy of the existing badges
                
                for achievement in userAchievements {
                    if achievement == "Diamond Collector" {
                        updatedBadges.remove(at: 0)
                        let badge = AchievementBadge(name: "Diamond Collector", imageName: "diamond-badge")
                        updatedBadges.insert(badge, at: 0)
                    }

                    if achievement == "Mine Sweeper" {
                        updatedBadges.remove(at: 1)
                        let badge = AchievementBadge(name: "Mine Sweeper", imageName: "bomb-badge")
                        updatedBadges.insert(badge, at: 1)
                    }
                }

                achievementBadges = updatedBadges  // Assign the updated badges back to the @State property
            }

        }
    }
    
    // Calculate win percentage based on users' highscores
    private func calculateWinPercentage() -> String {
        var users = userManager.loadUsers()
        var user = userExists(users: users, username: username, password: password)
        
        var totalGames = user?.totalGames ?? 0
        var winningGames = user?.winGames ?? 0
        var winPercentage = Double(winningGames) / Double(totalGames) * 100
        
        let formattedWinPercentage = String(format: "%.2f", winPercentage)
        
        return formattedWinPercentage
    }
    
    // Calculate win percentage based on users' highscores
    private func getTotalGames() -> Int {
        var users = userManager.loadUsers()
        var user = userExists(users: users, username: username, password: password)
        
        var totalGames = user?.totalGames ?? 0
        return totalGames
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
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(userManager: UserManager(), username: "", password: "", isDarkMode: .constant(false))
    }
}

// Model for AchievementBadge
struct AchievementBadge: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

// View for displaying AchievementBadge
struct AchievementBadgeView: View {
    let badge: AchievementBadge
    
    @State var uiWidth = UIScreen.main.bounds.width
    @State var uiHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Image(badge.imageName)
                .resizable()
                .frame(width: uiWidth * 0.2, height: uiWidth * 0.2)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(10)
            Text(badge.name)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 10)
    }
}

