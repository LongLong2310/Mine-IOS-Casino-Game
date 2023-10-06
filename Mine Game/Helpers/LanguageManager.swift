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

import Foundation
import Combine

class LanguageManager: ObservableObject {
    static let shared = LanguageManager()
    
    @Published var selectedLanguageIndex = 0 {
        didSet {
            let selectedLanguage = availableLanguages[selectedLanguageIndex].name
            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            // Notify views to reload
            objectWillChange.send()
        }
    }
    
    private let availableLanguages = [
        Language(id: 0, name: "English"),
        Language(id: 1, name: "Spanish"),
        Language(id: 2, name: "Vietnamese")
    ]
}
