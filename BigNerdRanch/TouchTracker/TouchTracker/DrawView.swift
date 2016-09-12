//
//  DrawView.swift
//  TouchTracker
//
//  Created by Lucas Domene Firmo on 9/12/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var currentLines = [NSValue: Line]()
    var finishedLines = [Line]()
    var selectedLineIndex: Int? {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.sharedMenuController()
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.redColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.requireGestureRecognizerToFail(doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
    }
    
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.Round
        
        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        path.stroke()
    }
    
    func indexOfLineAtPoint(point: CGPoint) -> Int? {
        for (index, line) in finishedLines.enumerate() {
            let begin = line.begin
            let end = line.end
            
            for t in CGFloat(0).stride(to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        
        return nil
    }
    
    override func drawRect(rect: CGRect) {
        finishedLineColor.setStroke()
        for line in finishedLines {
            strokeLine(line)
        }
        
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            strokeLine(line)
        }
        
        if let index = selectedLineIndex {
            UIColor.greenColor().setStroke()
            let selectedLine = finishedLines[index]
            strokeLine(selectedLine)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInView(self)
            let newLine = Line(begin: location, end: location)
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }

        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.locationInView(self)
        }

        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.locationInView(self)
                finishedLines.append(line)
                currentLines.removeValueForKey(key)
            }
        }

        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    func doubleTap(gestureRecognizer: UIGestureRecognizer) {
        selectedLineIndex = nil
        currentLines.removeAll(keepCapacity: false)
        finishedLines.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
    func tap(gestureRecognizer: UITapGestureRecognizer) {
        let point = gestureRecognizer.locationInView(self)
        selectedLineIndex = indexOfLineAtPoint(point)
        
        let menu = UIMenuController.sharedMenuController()
        
        if selectedLineIndex != nil {
            becomeFirstResponder()
            
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            menu.menuItems = [deleteItem]
            
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height: 2), inView: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            menu.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func deleteLine(sender: AnyObject) {
        if let index = selectedLineIndex {
            finishedLines.removeAtIndex(index)
            selectedLineIndex = nil
            setNeedsDisplay()
        }
    }
}
