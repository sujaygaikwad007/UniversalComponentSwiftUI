//
//  HelperFunction.swift
//  UniversalComponent
//
//  Created by Sujay Gaikwad on 24/02/25.
//

import Foundation
import SwiftUI



//Find a current date
func getCurrentDate(format: String = "yyyy-MM-dd") -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = format
    return formatter.string(from: date)
}


//Hide keyboard for all over app
func hideKeyboard(){
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}


//Format number  and 3 dots after number is greater than 3 digit
func formatValuesGreaterThreeDigit(text: String) -> String {
    let regex = try! NSRegularExpression(pattern: "\\d+(\\.\\d+)?")
    let matches = regex.matches(in: text, range: NSRange(text.startIndex..., in: text))
    
    var modifiedText = text
    
    for match in matches.reversed() { // Process matches in reverse to avoid index shifting
        if let range = Range(match.range, in: text) {
            let numberString = String(text[range])
            let parts = numberString.split(separator: ".")
            let integerPart = parts[0]
            
            if integerPart.count > 3 {
                let formattedNumber = String(integerPart.prefix(3)) + "..."
                modifiedText.replaceSubrange(range, with: formattedNumber)
            }
        }
    }
    
    return modifiedText
}


//Print response in jSon
func printJSON<T: Encodable>(_ object: T) {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .prettyPrinted
    do {
        let jsonData = try encoder.encode(object)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Response JSON----------->\n", jsonString)
        }
    } catch {
        print("Error encoding JSON:", error.localizedDescription)
    }
}

