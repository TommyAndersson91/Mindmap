//
//  BubbleView.swift
//  Mindmap
//
//  Created by Tommy Andersson on 2019-04-11.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import UIKit

protocol BubbleViewDelegate {
    func didSelect(_ bubble: BubbleView)
    func didEdit (_ bubble: BubbleView)
}

class BubbleView: UIView {

    
    var lines = [LineView]()
    
    var delegate: BubbleViewDelegate?
    var color: UIColor? //Bakgrundsfärg som vi byter till efter avmarkering
    var label = UILabel()
    
    //MARK: Init
    
    init(_ atPoint: CGPoint) {
        
        
        let size: CGFloat = 80
        let frame = CGRect(x: atPoint.x-size/2, y: atPoint.y-size/2, width: 80, height: 80)
        super.init(frame: frame)
        
        backgroundColor = UIColor.random()
        self.layer.cornerRadius = size/2
        self.clipsToBounds = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(didPanInBubble(_:)))
         self.addGestureRecognizer(pan)
     
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapInBubble(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
       
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapInBubble(_:)))
        tap.require(toFail: doubleTap)
        self.addGestureRecognizer(tap)
        //Skapa en label för din bubbla
        label.frame = bounds
        label.textAlignment = .center
        label.numberOfLines = 3
        label.text = "Text"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 15)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Gestures
    
    @objc func didPanInBubble(_ gesture: UIPanGestureRecognizer) {
        print("did pan")
        
        
         if gesture.state == .changed {
        self.center = gesture.location(in: superview)
         //Uppdatera alla linjer
            for line in lines {
                line.update()
            }
        }   else if gesture.state == .began {
            superview?.bringSubviewToFront(self)
        }
        
        
        
    }
    
    @objc func didTapInBubble(_ gesture: UITapGestureRecognizer) {
        print("did tap in bubble")
        
        guard  let bubble = gesture.view as? BubbleView else {
            return
        }
        if delegate != nil {
            delegate!.didSelect(bubble)
        }
        
    
}
    
    
    @objc func didDoubleTapInBubble(_ gesture: UITapGestureRecognizer) {
        print("did double tap in bubble")
        
        guard  let bubble = gesture.view as? BubbleView else {
            return
        }
        if delegate != nil {
            delegate!.didEdit(bubble)
        }
        
        
    }
    
    func select() {
        color = backgroundColor
        backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    }
    
    func deselect() {
        backgroundColor = color
    }
    
    func delete() {
        for line in lines {
            line.removeFromSuperview()
        }
        removeFromSuperview()
    }
    
}

extension UIColor {
    
    static func random() -> UIColor {
     
        let randomRed = CGFloat(arc4random_uniform(256))/255.0
         let randomGreen = CGFloat(arc4random_uniform(256))/255.0
         let randomBlue = CGFloat(arc4random_uniform(256))/255.0
        
      return  UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    
    }
}

