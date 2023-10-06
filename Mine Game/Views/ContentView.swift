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

struct ContentView: View {
    @StateObject private var userManager = UserManager()
//    @EnvironmentObject var audioManagerWrapper: AudioManagerWrapper
    var body: some View {
        SignUpLoginView(userManager: userManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject private var userManager = UserManager()
    static var previews: some View {
        ContentView()
    }
}

