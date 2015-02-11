//
//  UserController.swift
//  TextCrunch
//
//  Created by Philip Pabst on 2015-01-31.
//  Copyright (c) 2015 Text Crunch. All rights reserved.
//

import Foundation


//The base UserController class for non-social network user management.
public class UserController {
    
    enum UCCode : Int {
        case LOGINFAIL_PASSWORD = 0
        case LOGINFAIL_NEXIST
        case LOGINFAIL_EMAIL
        case LOGINFAIL_MISC
        case LOGINSUCCESS
        
        case CREATEFAIL_MISC
        case CREATEFAIL_EMAILEXISTS
        case CREATESUCCESS
    }
    
    
    //Logs in using the passed in User, setting it as the app's current user.
    //Returns a UCCode indicating the success or failure of logging in the user.
    //Returns .LOGINSUCCESS, .LOGINFAIL_NEXIST, .LOGINFAIL_PASSWORD, or .LOGINFAIL_MISC
    func loginUser(user: PSUser, password: String) -> UCCode {
        var resultCode = UCCode.LOGINFAIL_MISC
        var errorResult : NSError?
        var resultUser = PFUser.logInWithUsername(user.email, password: password, error: &errorResult)
        if (resultUser == nil){//Either the account doesn't exist or the password is wrong.
            var query = PFUser.query()
            query.whereKey("username", equalTo: user.email)
            //Checks to see if an account with the given username/email exists,
            //if there is one the error must be that the password is wrong.
            var queryResults = query.findObjects()
            if (queryResults.count == 0){
                resultCode = .LOGINFAIL_NEXIST
            } else {
                resultCode = .LOGINFAIL_PASSWORD
            }
        } else {
            resultCode = .LOGINSUCCESS
        }
        return resultCode
    }
    
    
    //Adds the passed user model to Parse as a new user.
    //Returns a UCCode indicating the success or failure of adding the user.
    //Returns .CREATESUCCESS, .CREATEFAIL_EMAILEXISTS, or .CREATEFAIL_MISC.
    //Currently adds the user synchronously.
    func createUserAccount(user: PSUser, password: String) -> UCCode{
        
        user.password = password
        
        var resultCode = UCCode.CREATEFAIL_MISC
        var error: NSError?

        var result = user.signUp(&error)
        
        if(!result) {
            println("User creation error: \(error)")
            resultCode = UCCode.CREATEFAIL_EMAILEXISTS
        } else {
            resultCode = UCCode.CREATESUCCESS
        }
        
        return resultCode
    }
    
    
    //Returns a User representing the currently logged-in user, or nil if no user is logged in.
    func getCurrentUser()-> PSUser! {
        
        var currentPFUser = PSUser.currentUser()
        
        if (currentPFUser == nil){
            return nil
        }
        
        return currentPFUser
    }
    
    //Deletes the account of the user currently logged in.
    //Returns true if the deletion was successful and false if it was not.
    func deleteCurrentUserAccount() -> Bool {
        var currentUser = PFUser.currentUser()
        var result = currentUser.delete()
        return result
    }
    
    //Logs out the current user.
    //Returns true if the logout was sucessful and false if there is still a user logged in.
    func logoutCurrentUser() -> Bool {
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        return (currentUser == nil)
    }
    
    //Initiates password reset with Parse by sending the user a password reset email.
    func resetCurrentUserPassword() -> Void{
        var currentUser = PFUser.currentUser()
        PFUser.requestPasswordResetForEmailInBackground(currentUser.email, block: nil)
        return
    }
    
    //Incomplete until the
    func getUsersSoldListings(user: PSUser) -> [Listing]?{
        return nil
    }
    
    func getUsersBoughtListings(user: PSUser) -> [Listing]?{
        return nil
    }
    
    func getUsersActiveListings(user: PSUser) -> [Listing]?{
        return nil
    }
    
}






