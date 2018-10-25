//
//  ViewController.swift
//  Set
//
//  Created by Eugene Rozenberg on 23/10/2018.
//  Copyright © 2018 Eugene Rozenberg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = SetGame()
    
    @IBOutlet var cardButtons: [UIButton]! {
        didSet {
            updateViewFromModel()
        }
    }
    
    @IBOutlet var dealCardsButton: UIButton! {
        didSet {
            updateViewFromModel()
        }
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        game.newGame()
        updateViewFromModel()
    }
    
    @IBAction func touchDealMoreCardsButton(_ sender: UIButton) {
        game.draw()
        updateViewFromModel()
    }

    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            
            if (game.isGameStarted) {
                if let card = game.openCards.get(at: index) {
                    button.layer.cornerRadius = 8.0
                    
                    let symbols = extractSymbolsFrom(card)
                    button.isHidden = false
                    button.setAttributedTitle(symbols, for: .normal)
                    
                    if (card.isSelected) {
                        button.layer.borderWidth = 3.0
                        button.layer.borderColor = UIColor.blue.cgColor
                    } else {
                        button.layer.borderWidth = 0.0
                    }
                } else {
                    button.isHidden = true
                    button.setTitle("", for: UIControl.State.normal)
                }
                
            } else {
                button.isHidden = true
                button.setTitle("", for: UIControl.State.normal)
            }
        }
        
        updateDealCardsButton()
    }
    
    private func updateDealCardsButton() {
        dealCardsButton?.isEnabled = game.isGameStarted && game.canDealMoreCards
    }
    
    private func extractSymbolsFrom(_ card: Card) -> NSAttributedString {
        var attributes = [NSAttributedString.Key : Any]()
        addColorAndShading(attributes : &attributes, color : card.color, shading: card.shading)
        let symbols = extractSymbolsFrom(number: card.number, symbol: card.symbol)
        switch card.symbol {
        case .diamond: return centeredAttributedString(string: symbols, attributes: attributes, fontSize: 20)
        case .oval: return centeredAttributedString(string: symbols, attributes: attributes, fontSize: 20)
        case .squiggle: return centeredAttributedString(string: symbols, attributes: attributes, fontSize: 20)
        }
    }
    
    private func extractSymbolsFrom(number: Card.Number, symbol: Card.Symbol) -> String {
        var result: String = ""
        for _ in 1...number.rawValue {
            switch symbol {
            case .diamond:
                result.append("■\r\n")
                break
            case .oval:
                result.append("●\r\n")
                break
            case .squiggle:
                result.append("▲\r\n")
                break
            }
        }
        return result
    }
    
    private func centeredAttributedString(string: String,
                                          attributes: [NSAttributedString.Key : Any],
                                          fontSize: CGFloat) -> NSAttributedString {
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        var attributesWithStyle = attributes
        attributesWithStyle.updateValue(font, forKey: .font)
        attributesWithStyle.updateValue(paragraphStyle, forKey: .paragraphStyle)
        
        return NSAttributedString(string: string, attributes: attributesWithStyle)
    }
    
    private func addColorAndShading(attributes: inout [NSAttributedString.Key : Any],
                          color cardColor: Card.Color,
                          shading: Card.Shading) {
        var color: UIColor
        
        switch cardColor {
        case .green:
            color = UIColor.green
            break
        case .purple:
            color = UIColor.purple
            break
        case .red:
            color = UIColor.red
            break
        }
        
        switch shading {
        case .open:
            attributes.updateValue(3, forKey: .strokeWidth)
            break
        case .solid:
              color.withAlphaComponent(1)
            break
        case .striped:
            color = color.withAlphaComponent(0.15)
            break
        }
        
        attributes.updateValue(color, forKey: .foregroundColor)
    }
}

