//
//  JSONParser.swift
//  Task-DIP
//
//  Created by Георгий on 13/07/2018.
//  Copyright © 2018 Георгий. All rights reserved.
//

import UIKit

enum JSON {
    case String(String)
    case Number(Double)
    case Object([String : JSON])
    case Array([JSON])
    case Bool(Bool)
    case Null
}

enum ParseError: Error {
    case invalidInput
    case dontMatch
}

extension JSON {
//    struct ErrorList {
//        static let string = "String cant convert to Integer or Double"
//        static let number = "Number cant convert to Line, Integer or PhoneNumber"
//        static let bool = "Bool cant convert to Line, Integer, Double or PhoneNumber"
//        static let phone = "Phone number is invalid"
//
//        static let null = "The object was NULL"
//    }
    
    func encode(_ type: InputType) -> Any? {
        switch self {
        case .String(let string):
            return processString(string, type)
        case .Number(let number):
            return processNumber(number, type)
        case .Object(let object):
            return object.flatMap({[$0.key: $0.value.encode(type)]})
        case .Array(let array):
            return array.map({$0.encode(type)})
        case .Bool(let bool):
            return processBool(bool, type)
        case .Null:
            return nil
        }
    }
    
    func processString(_ string: String, _ type: InputType) -> Any {
        switch type {
        case .Line:
            return Swift.String(string)
        case .Integer:
            if let integer = Int(string) {
                return integer
            }
            return ParseError.invalidInput
        case .Double:
            if let double = Double(string) {
                return double
            }
            return ParseError.invalidInput
        case .PhoneNumber:
            return validatePhone(string)
        }
    }
    
    func processNumber(_ number: Double, _ type: InputType) -> Any {
        switch type {
        case .Double:
            return Swift.Double(number)
        case .Line:
            return Swift.String(number)
        case .Integer, .PhoneNumber:
            return ParseError.invalidInput
        }
    }
    
    func processBool(_ bool: Bool, _ type: InputType) -> Any {
        switch type {
        case .Line:
            return Swift.String(bool)
        case .Double, .Integer, .PhoneNumber:
            return ParseError.invalidInput
        }
    }
    
    func validatePhone(_ value: String) -> Any {
        let PHONE_REGEX = "^((8|\\+?7)[\\- ]?)(\\(?\\d{3}\\)?[\\- ]?)?[\\d\\- ]{7,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let isValid =  phoneTest.evaluate(with: value)
        
        if isValid {
            let REPLACE_REGES = "(^8|\\+?7)|(\\D)"
            let expresion = try! NSRegularExpression(pattern: REPLACE_REGES, options: [])
            
            return "7" + expresion.stringByReplacingMatches(in: value, options: [], range: NSMakeRange(0, value.count - 1), withTemplate: "")
        }
        
        return ParseError.dontMatch
    }
}

enum InputType {
    case Line
    case Integer
    case Double
    case PhoneNumber
}



class JSONParser: NSObject {

    // MARK: Public functions
    
    func convert(object: JSON?, type: InputType) -> Any? {
        guard let object = object else {
            return nil
        }
        
        // Encode to Any
        let encodedObject = object.encode(type)

        return encodedObject
    }  
}
