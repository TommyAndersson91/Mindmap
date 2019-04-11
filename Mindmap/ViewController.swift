//
//  ViewController.swift
//  Mindmap
//
//  Created by Tommy Andersson on 2019-04-11.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BubbleViewDelegate, UIScrollViewDelegate {
    
  

       var selectedBubble: BubbleView?
    var superScrollView: UIScrollView?
    var superContentView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Konfigurera Scrollvy
        superScrollView = UIScrollView(frame: view.bounds)
        superScrollView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        superScrollView?.delegate = self
        let contentSize: CGFloat = 2000
        superScrollView?.contentSize = CGSize(width: contentSize, height: contentSize)
        superScrollView?.contentOffset = CGPoint(x: contentSize - view.frame.size.width/2, y: view.frame.size.height/2)
        
        superScrollView?.minimumZoomScale = 0.5
        superScrollView?.maximumZoomScale = 2.0
        
        //Konfigurera Content view
        superContentView = UIView(frame: CGRect(x: 0, y: 0, width: contentSize, height: contentSize))
        superScrollView?.addSubview(superContentView!)
        
        //Lägga till vår scrollvy i vår container
        view.addSubview(superScrollView!)
        
        // Lägga till en tap gesture (för att skapa nya bubblor)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        superContentView?.addGestureRecognizer(tap)
    }

    
    func didEdit(_ bubble:BubbleView) {
        //TOOD: Visa Popup med textfält
        let textInput = UIAlertController(title: "Edit bubble text", message: "Enter the text you want in the bubble", preferredStyle: .alert)
        textInput.addTextField { (textField) in
            textField.text = bubble.label.text
        }
        textInput.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            let textField = textInput.textFields![0] as UITextField
            bubble.label.text = textField.text
        }))
        self.present(textInput, animated: true, completion: nil)
    }

    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        //Hitta CGPoint och lägg till bubbla.
        
        print("did tap")
        if selectedBubble != nil {
            selectedBubble?.deselect()
            selectedBubble = nil
            
        } else {
             let tapPoint = gesture.location(in: superContentView)
            let bubble = BubbleView(tapPoint)
            bubble.delegate = self
            superContentView!.addSubview(bubble)
     
    }
    }
    
 
    
    //MARK: BubbleViewDelegate
    func didSelect(_ bubble: BubbleView) {
        if selectedBubble != nil {
            if bubble == selectedBubble {
                // Delete bubble
                bubble.delete()
                
            } else {
                // Connect bubbles
                let line = LineView(from: selectedBubble!, to: bubble)
                superContentView!.insertSubview(line, at: 0)
                selectedBubble?.lines.append(line)
                bubble.lines.append(line)
            }
            //Deselect selectedBubble
            selectedBubble?.deselect()
            selectedBubble = nil
        } else {
            selectedBubble = bubble
            selectedBubble?.select()
        }
        
    }
    
    //MARK: UIScrollViewDelegate
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return superContentView
    }
    }
    
 
    

    
    


