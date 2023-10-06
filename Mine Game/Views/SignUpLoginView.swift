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

struct User: Identifiable, Codable {
    var id = UUID() // Use UUID for the id property
    
    let username: String
    let password: String
    var balance: Double
    var highscore: Double
    var achievements: [String]
    var totalGames: Int
    var winGames: Int
}

class UserManager: ObservableObject {
    @Published var users: [User] = []
    var loggedInUser: User?

    init() {
        self.users = loadUsers()
    }

    func addUser(username: String, password: String, balance: Double, highscore: Double, achievements: [String], totalGames: Int, winGames: Int) {
        let newUser = User(username: username, password: password, balance: balance, highscore: highscore, achievements: achievements, totalGames: totalGames, winGames: winGames)
        users.append(newUser)
        saveUsers()
    }

    public func userExists(username: String, password: String) -> Bool {
            if let matchedUser = users.first(where: { user in
                user.username == username && user.password == password
            }) {
                loggedInUser = matchedUser // Set loggedInUser if matched
                return true
            } else {
                return false
            }
        }
    
    public func userExists(username: String, password: String) -> User? {
        if let matchedUser = users.first(where: { user in
            user.username == username && user.password == password
        }) {
            return matchedUser // Return the matched user
        } else {
            return nil // Return nil if no match is found
        }
    }

    public func saveUsers() {
        let encodedData = try? JSONEncoder().encode(users)
        UserDefaults.standard.set(encodedData, forKey: "users")
    }

    public func loadUsers() -> [User] {
        guard let userData = UserDefaults.standard.data(forKey: "users") else {
            return []
        }
        return (try? JSONDecoder().decode([User].self, from: userData)) ?? []
    }
    
    // Function to update user's balance and save the changes
    func updateUserBalance(username: String, newBalance: Double) {
        guard let userIndex = users.firstIndex(where: { $0.username == username }) else {
            return // User not found
        }
        
        users[userIndex].balance = newBalance
        saveUsers()
    }
    
    func updateUserHighScore(username: String, newHighscore: Double) {
        guard let userIndex = users.firstIndex(where: { $0.username == username }) else {
            return // User not found
        }
        
        users[userIndex].highscore = newHighscore
        saveUsers()
    }
    
    func updateUserTotalGamesAndWinGames(username: String, newTotalGames: Int, newWinGames: Int) {
        guard let userIndex = users.firstIndex(where: { $0.username == username }) else {
            return // User not found
        }
        
        users[userIndex].totalGames = newTotalGames
        users[userIndex].winGames = newWinGames
        saveUsers()
    }
    
    func updateUserAchievements(username: String, newAchievements: [String]) {
        // Find the index of the user in the array
        if let userIndex = users.firstIndex(where: { $0.username == username }) {
            var user = users[userIndex]
            
            // Append the new achievements to the existing list
            user.achievements.append(contentsOf: newAchievements)
            
            // Update the user in the array
            users[userIndex] = user
            
            // Save the updated users array
            saveUsers()
        }
    }
}


struct SignUpLoginView: View {
    @ObservedObject var userManager: UserManager
    @State private var username = ""
    @State private var password = ""
    @State private var isShowingSignUp = false
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @State var isLogedIn: Bool = false

    @State var uiWidth = UIScreen.main.bounds.width
    @State var uiHeight = UIScreen.main.bounds.height

    var body: some View {
        if(isLogedIn) {
            MenuView(userManager: userManager, selectedDifficulty: .easy, username: username, password: password)
        }
        else {
            ZStack {
                Color(hex: "#071d2a")
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Image("mines_login_signup")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: uiWidth * 0.5, height: uiHeight * 0.3)
                        .cornerRadius(50)
                        .padding(.top)
                    
                    HStack {
                        Text("Login")
                            .font(.system(size: 40))
                            .bold()
                            .foregroundColor(Color.white)
                            .padding()
                        
                        Spacer()
                    }
                    .padding(.top)

                    VStack(spacing: 20) {
                        TextField("Username", text: $username)
                            .padding()
                            .frame(width: uiWidth * 0.84)
                            .autocapitalization(.none)
                            .background(Color(hex: "#3d5564"))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .colorScheme(.dark)
                            

                        SecureField("Password", text: $password)
                            .padding()
                            .frame(width:  uiWidth * 0.84)
                            .autocapitalization(.none)
                            .background(Color(hex: "#3d5564"))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .colorScheme(.dark)
                    }
                    .padding(.top)
                    
                    Spacer()

                    Button {
                        if userManager.userExists(username: username, password: password) {
                            // Successful login action
                            alertMessage = "Login successful!"
                            isShowingAlert = true
                        } else {
                            // Failed login action
                            alertMessage = "Login failed. Invalid credentials."
                        }
                    } label: {
                        Text(("Login"))
                            .frame(width:  uiWidth * 0.84, height: uiHeight * 0.16)
                    }
                    .padding(.all)
                    .frame(width:  uiWidth * 0.84, height:  uiWidth * 0.16)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .alert(isPresented: $isShowingAlert) {
                        Alert(title: Text(alertMessage), message: Text(""), dismissButton: .default(Text("OK"), action: {isLogedIn = true}))
                    }


                    Spacer()

                    HStack {
                        Text("Don't have an Account?")
                            .foregroundColor(.white)
                        Button("Sign Up") {
                            isShowingSignUp = true
                        }
                        .sheet(isPresented: $isShowingSignUp) {
                            SignUpView(userManager: userManager)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct SignUpView: View {
    @ObservedObject var userManager: UserManager
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var password = ""
    
    @State var uiWidth = UIScreen.main.bounds.width
    @State var uiHeight = UIScreen.main.bounds.height

    var body: some View {
        ZStack {
            Color(hex: "#071d2a")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack {
                    Text("Create new account")
                        .font(.system(size: 28))
                        .bold()
                        .foregroundColor(Color.white)
                        .padding(.all)
                    
                    Text("Please fill in the form to continue")
                        .font(.system(size: 14))
                        .bold()
                        .foregroundColor(Color(hex: "#b1bad3"))
                }
                
                Spacer()
                    .frame(height: 100)

                TextField("Username", text: $username)
                    .padding()
                    .frame(width: uiWidth * 0.84)
                    .autocapitalization(.none)
                    .background(Color(hex: "#3d5564"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .colorScheme(.dark)


                SecureField("Password", text: $password)
                    .padding()
                    .frame(width: uiWidth * 0.84)
                    .background(Color(hex: "#3d5564"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .colorScheme(.dark)


                Spacer()
                    .frame(height: uiHeight * 0.3)
                Button() {
                    userManager.addUser(username: username, password: password, balance: 1000, highscore: 0, achievements: [], totalGames: 0, winGames: 0)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(("Sign Up"))
                        .frame(width:  uiWidth * 0.84, height: uiHeight * 0.07)
                }
                .padding(.all)
                .frame(width: uiWidth * 0.84, height: uiHeight * 0.07)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(20)
                
                HStack {
                    Text("Have an Account?")
                        .foregroundColor(.white)
                    Button("Sign In") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .padding(.top)
            }
            .padding()
        }
    }
}

struct SignUpLoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpLoginView(userManager: UserManager())
    }
}
