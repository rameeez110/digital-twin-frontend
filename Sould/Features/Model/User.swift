//
//  User.swift
//  Sould
//
//  Created by Rameez Hasan on 13/08/2022.
//

import UIKit

class User : NSObject,NSCoding {
    
    //MARK: - NSCoding -
    required init(coder aDecoder: NSCoder) {
        firstName = aDecoder.decodeObject(forKey: "firstName") as! String
        phone = aDecoder.decodeObject(forKey: "phone") as! String
        lastName = aDecoder.decodeObject(forKey: "lastName") as! String
        isVerified = aDecoder.decodeBool(forKey: "isVerified")
        hasTemporaryPassword = aDecoder.decodeBool(forKey: "hasTemporaryPassword")
        socialSignIn = aDecoder.decodeBool(forKey: "socialSignIn")
        email = aDecoder.decodeObject(forKey: "email") as! String
        userId = aDecoder.decodeObject(forKey: "userId") as! String
        let userTypeID = aDecoder.decodeInteger(forKey:"userType")
        userType = UserType.init(rawValue: userTypeID) ?? .Visitor
        let userRoleID = aDecoder.decodeInteger(forKey:"userRole")
        userRole = UserRole.init(rawValue: userRoleID) ?? .User
        token = aDecoder.decodeObject(forKey: "token") as! String
        image = aDecoder.decodeObject(forKey: "image") as! String
        password = aDecoder.decodeObject(forKey: "password") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(isVerified, forKey: "isVerified")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(userId, forKey: "userId")
        aCoder.encode(userType.rawValue, forKey: "userType")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(password, forKey: "password")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(userRole.rawValue, forKey: "userRole")
    }
    
    override init() {
        self.userId = ""
        self.email = ""
        self.password = ""
    }
    
    var phone = String()
    var email = String()
    var password = String()
    var firstName = String()
    var lastName = String()
    var image = String()
    var userId = String()
    var isVerified = false
    var socialSignIn = false
    var userType = UserType.Visitor
    var token = String()
    var hasTemporaryPassword = false
    var isFirstLogin = false
    var userRole = UserRole.User
    
    var dictionary: [String: Any] {
      return [
        "email": self.email,
        "password": self.password,
      ]
    }
    
    var registerDictionary: [String: Any] {
      return [
        "email": self.email,
        "password": self.password,
        "firstName": self.firstName,
        "lastName": self.lastName,
      ]
    }
    
    var profileDictionary: [String: Any] {
      return [
        "imageUrl": self.image,
        "phone": self.phone,
        "firstName": self.firstName,
        "lastName": self.lastName,
      ]
    }
    
    func getArchivedUser() -> User? {
        return self.getLocallySavedUser()
    }

    func getLocallySavedUser() -> User? {
        if let decoded  = UserDefaults.standard.object(forKey: Constants.UserDefaultsKey.archivedUser) as? Data {
            do {
                if let user = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded) as? User {
                    return user
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        } else {
            return nil
        }
        return nil
    }

    func removeUser() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultsKey.archivedUser)
        Session.sharedInstance.user = nil
        Session.sharedInstance.token = nil
    }

    func saveUser(user: User)
    {
        Session.sharedInstance.token = user.token
        Session.sharedInstance.user = user
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
            UserDefaults.standard.setValue(data, forKey: Constants.UserDefaultsKey.archivedUser)
        } catch {
            print("could not archive user")
        }
    }
}
