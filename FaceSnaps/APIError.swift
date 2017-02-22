//
//  APIError.swift
//  FaceSnaps
//
//  Created by Patrick Montalto on 2/18/17.
//  Copyright © 2017 Patrick Montalto. All rights reserved.
//

import UIKit

enum APIError: Error {
    case responseError(message: String?)
    case parseError(message: String?)
    case noJSON
    case missingKey(message: String?)
    case persistenceError
    
    func defaultMessage() -> String {
        switch self {
        case .missingKey(message: nil):
            return "Key missing from JSON response."
        case .noJSON:
            return "No JSON response from server."
        case .parseError(message: nil):
            return "An error occurred parsing the network response."
        case .responseError(message: nil):
            return "The server returned a response error."
        case .persistenceError:
            return "An error occurred saving to the database."
        default:
            return "An error occurred. Please try again later."
        }
    }
}

struct APIErrorHandler {
    static func handle(error: APIError, logError: Bool) -> String {
        // TODO: Handle errors based on types
        // Display UIAlert as needed
        var errorMessage: String!
        if case .responseError(let message) = error {
            errorMessage = message ?? error.defaultMessage()
        } else if case .parseError(let message) = error {
            errorMessage = message ?? error.defaultMessage()
        } else if case .noJSON = error {
            errorMessage = error.defaultMessage()
        } else if case .missingKey(let message) = error {
            errorMessage = message ?? error.defaultMessage()
        } else if case .persistenceError = error {
            errorMessage = error.defaultMessage()
        }
        
        if logError {
            print(errorMessage)
        }
        return errorMessage
    }
    
    static func handle(error: APIError, withActions actions: [UIAlertAction], presentingViewController: UIViewController) {
        let errorString = handle(error: error, logError: false)
        presentingViewController.displayAlert(withMessage: errorString, title: "Error", actions: actions)
    }
}

