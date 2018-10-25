//
//  SetGame.swift
//  Set
//
//  Created by Eugene Rozenberg on 23/10/2018.
//  Copyright © 2018 Eugene Rozenberg. All rights reserved.
//

import Foundation

struct SetGame {
    private(set) var deck = [Card]()
    private(set) var openCards = [Card]()
  
    struct Consts {
        static let FIRST_TIME_OPENED_CARDS = 12
        static let MAX_OPENED_CARDS = 24
        static let MAX_DRAW_CARDS = 3
    }
    
    var isGameStarted: Bool {
        get {
            return openCards.count > 0
        }
    }
    
    var canDealMoreCards: Bool {
        get {
            return openCards.count < Consts.MAX_OPENED_CARDS
        }
    }
    
    private func getSelectedCards() -> [Card] {
        return openCards.filter({ $0.isSelected == true })
    }
    
    private func isMatch() -> Bool {
        let selectedCards = getSelectedCards()
        
        if (selectedCards.count == 3) {
            return (satifiesRuleOfNumbers(cards: selectedCards)
                    && satifiesRuleOfColors(cards: selectedCards)
                    && satifiesRuleOfShadings(cards: selectedCards)
                    && satifiesRuleOfSymbols(cards: selectedCards))
        } else {
            return false
        }
    }
    
    private func satifiesRuleOfNumbers(cards: [Card]) -> Bool {
        return (cards[0].number == cards[1].number
        && cards[1].number == cards[2].number)
        || (cards[0].number != cards[1].number
            && cards[1].number != cards[2].number
            && cards[0].number != cards[2].number)
    }
    
    private func satifiesRuleOfColors(cards: [Card]) -> Bool {
        return (cards[0].color == cards[1].color
            && cards[1].color == cards[2].color)
            || (cards[0].color != cards[1].color
                && cards[1].color != cards[2].color
                && cards[0].color != cards[2].color)
    }
    
    private func satifiesRuleOfShadings(cards: [Card]) -> Bool {
        return (cards[0].shading == cards[1].shading
            && cards[1].shading == cards[2].shading)
            || (cards[0].shading != cards[1].shading
                && cards[1].shading != cards[2].shading
                && cards[0].shading != cards[2].shading)
    }
    
    private func satifiesRuleOfSymbols(cards: [Card]) -> Bool {
        return (cards[0].symbol == cards[1].symbol
            && cards[1].symbol == cards[2].symbol)
            || (cards[0].symbol != cards[1].symbol
                && cards[1].symbol != cards[2].symbol
                && cards[0].symbol != cards[2].symbol)
    }
    
    mutating func newGame() {
        openCards.removeAll()
        deck.removeAll()
        
        for number in Card.Number.allCases {
            for symbol in Card.Symbol.allCases {
                for shading in Card.Shading.allCases {
                    for color in Card.Color.allCases {
                        let card = Card(number, symbol, shading, color)
                        deck.append(card)
                    }
                }
            }
        }
        deck.shuffle()
        draw(numOfCards: Consts.FIRST_TIME_OPENED_CARDS)
    }
    
    private mutating func draw(numOfCards num: Int) {
        for _ in 1...num {
            let endIndex = deck.endIndex
            let index = endIndex.arc4random()
            let openedCard = deck.remove(at: index)
            openCards.append(openedCard)
        }
    }
    
    public mutating func draw() {
        let numOfCard = Consts.MAX_OPENED_CARDS - openCards.count >= Consts.MAX_DRAW_CARDS
            ? Consts.MAX_DRAW_CARDS
            : Consts.MAX_OPENED_CARDS - openCards.count
        draw(numOfCards: numOfCard)
    }
    
    fileprivate mutating func removeSelectedCards() {
        let selectedCards = getSelectedCards()
        
        for selectedCard in selectedCards {
            if let selectedCardIndex = openCards.index(of: selectedCard) {
                openCards.remove(at: selectedCardIndex)
            }
        }
    }
    
    fileprivate mutating func unselectCards() {
        let selectedCards = getSelectedCards()
        
        for selectedCard in selectedCards {
            if let selectedCardIndex = openCards.index(of: selectedCard) {
                openCards[selectedCardIndex].isSelected = false
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        removeMatchedCards()
        
        if var openedCard = openCards.get(at: index) {
            openedCard.isSelected = !openedCard.isSelected
            openCards[index] = openedCard
        }
        
        unselectCardsIfNoMatch()
    }
    
    private mutating func removeMatchedCards() {
        let selectedCards = getSelectedCards()
        
        if selectedCards.count == 3 && isMatch() { removeSelectedCards() }
    }
    
    private mutating func unselectCardsIfNoMatch() {
        let selectedCards = getSelectedCards()
        
        if selectedCards.count == 3 && !isMatch() { unselectCards() }
    }
}

extension Int {
    func arc4random() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}

extension Array {
    // Safely lookup an index that might be out of bounds,
    // returning nil if it does not exist
    func get(at index: Int) -> Element? {
        if 0 <= index && index < count {
            return self[index]
        } else {
            return nil
        }
    }
}
