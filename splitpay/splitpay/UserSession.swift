import Foundation
import SwiftUI

// MARK: - User Session Model
// Stores user data entered on login page and shares across app

class UserSession: ObservableObject {
    static let shared = UserSession()
    
    @Published var userName: String = ""
    @Published var phoneNumber: String = ""
    @Published var numberOfPeople: Int = 2
    
    // Validation
    var isPhoneValid: Bool {
        let digitsOnly = phoneNumber.filter { $0.isNumber }
        return digitsOnly.count == 10
    }
    
    var isNameValid: Bool {
        return userName.trimmingCharacters(in: .whitespaces).count >= 2
    }
    
    var isFormValid: Bool {
        return isNameValid && isPhoneValid && numberOfPeople >= 2
    }
    
    // Formatted phone for display (masked)
    var maskedPhone: String {
        guard phoneNumber.count >= 10 else { return phoneNumber }
        let digitsOnly = phoneNumber.filter { $0.isNumber }
        let prefix = String(digitsOnly.prefix(2))
        let suffix = String(digitsOnly.suffix(4))
        return "\(prefix)XXXX\(suffix)"
    }
    
    private init() {}
    
    func reset() {
        userName = ""
        phoneNumber = ""
        numberOfPeople = 2
    }
}

// MARK: - Group Member Model
// Represents a person in the bill split group

struct GroupMember: Identifiable {
    let id = UUID()
    let name: String
    let phone: String
    var hasPaid: Bool
    var amount: Int
    var isCurrentUser: Bool
    
    var maskedPhone: String {
        guard phone.count >= 10 else { return phone }
        let prefix = String(phone.prefix(2))
        let suffix = String(phone.suffix(4))
        return "\(prefix)XXXX\(suffix)"
    }
}
