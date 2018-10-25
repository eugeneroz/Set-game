//
//  Card.swift
//  Set
//
//  Created by Eugene Rozenberg on 23/10/2018.
//  Copyright © 2018 Eugene Rozenberg. All rights reserved.
//

import Foundation

struct Card: Equatable, CustomStringConvertible {
    var description: String {
        return "\(number) \(symbol) \(shading) \(color)"
    }
    
    let number: Number
    let symbol: Symbol
    let shading: Shading
    let color: Color
    
    var isSelected: Bool = false
  
    init(_ number: Number, _ symbol: Symbol, _ shading: Shading, _ color: Color) {
        self.number = number
        self.symbol = symbol
        self.shading = shading
        self.color = color
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.color == rhs.color
                && lhs.number == rhs.number
                && lhs.shading == rhs.shading
                && lhs.symbol == rhs.symbol
    }
    
    enum Number: Int, CaseIterable, CustomStringConvertible {
        var description: String {
            return "\(self.rawValue)"
        }
        
        case one = 1
        case two = 2
        case three = 3
    }
    
    enum Symbol: String, CaseIterable {
        case diamond = "diamond"
        case squiggle = "squiggle"
        case oval = "oval"
    }
    
    enum Shading: String, CaseIterable {
        case solid = "solid"
        case striped = "striped"
        case open = "open"
    }
    
    enum Color: String, CaseIterable {
        case red = "red"
        case green = "green"
        case purple = "purple"
    }
}
