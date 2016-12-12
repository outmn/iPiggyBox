//  RAMPaperSwitch.swift
//
// Copyright (c) 26/11/14 Ramotion Inc. (http://ramotion.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class RAMPaperSwitch: UISwitch {
    
    @IBInspectable var duration: Double = 0.35
    
    var animationDidStartClosure = {(onAnimation: Bool) -> Void in }
    var animationDidStopClosure = {(onAnimation: Bool, finished: Bool) -> Void in }
    
    fileprivate var shape: CAShapeLayer! = CAShapeLayer()
    fileprivate var radius: CGFloat = 0.0
    fileprivate var oldState = false
  
    override var isOn: Bool {
        didSet(oldValue) {
            oldState = isOn
        }
    }
  
    override func setOn(_ on: Bool, animated: Bool) {
        let changed:Bool = on != self.isOn
        
        super.setOn(on, animated: animated)
        
        if changed {
            if animated {
                switchChanged()
            } else {
                showShapeIfNeed()
            }
        }
    }
    
    
    override func layoutSubviews() {
        let x:CGFloat = max(frame.midX, superview!.frame.size.width - frame.midX);
        let y:CGFloat = max(frame.midY, superview!.frame.size.height - frame.midY);
        radius = sqrt(x*x + y*y);
        
        shape.frame = CGRect(x: frame.midX - radius,  y: frame.midY - radius, width: radius * 2, height: radius * 2)
        shape.anchorPoint = CGPoint(x: 0.5, y: 0.5);
        shape.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)).cgPath
    }


    override func awakeFromNib() {        
        let shapeColor:UIColor = (onTintColor != nil) ? onTintColor! : UIColor.green
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.white.cgColor;
        layer.cornerRadius = frame.size.height / 2;
        
        shape.fillColor = shapeColor.cgColor
        shape.masksToBounds = true
        
        superview?.layer.insertSublayer(shape, at: 0)
        superview?.layer.masksToBounds = true
        
        showShapeIfNeed()
        
        addTarget(self, action: #selector(RAMPaperSwitch.switchChanged), for: UIControlEvents.valueChanged)
      
        super.awakeFromNib()
    }
  
    
    fileprivate func showShapeIfNeed() {
        shape.transform = isOn ? CATransform3DMakeScale(1.0, 1.0, 1.0) : CATransform3DMakeScale(0.0001, 0.0001, 0.0001)
    }


    internal func switchChanged() {
        if isOn == oldState {
            return;
        }
        oldState = isOn
      
        if isOn {
            CATransaction.begin()
            
            shape.removeAnimation(forKey: "scaleDown")
            
            let scaleAnimation:CABasicAnimation  = animateKeyPath("transform",
                fromValue: NSValue(caTransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)),
                toValue:NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
                timing:kCAMediaTimingFunctionEaseIn);
            
            shape.add(scaleAnimation, forKey: "scaleUp")
            
            CATransaction.commit();
        }
        else {
            CATransaction.begin()
            shape.removeAnimation(forKey: "scaleUp")
            
            let scaleAnimation:CABasicAnimation  = animateKeyPath("transform",
                fromValue: NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),
                toValue:NSValue(caTransform3D: CATransform3DMakeScale(0.0001, 0.0001, 0.0001)),
                timing:kCAMediaTimingFunctionEaseOut);
                
            shape.add(scaleAnimation, forKey: "scaleDown")
            
            CATransaction.commit();
        }
    }
    
    
    fileprivate func animateKeyPath(_ keyPath: String, fromValue from: AnyObject, toValue to: AnyObject, timing timingFunction: String) -> CABasicAnimation {
    
        let animation:CABasicAnimation = CABasicAnimation(keyPath: keyPath)
        
        animation.fromValue = from
        animation.toValue = to
        animation.repeatCount = 1
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.duration = duration;
        animation.delegate = self
        
        return animation;
    }
    
    
    //CAAnimation delegate
    
    
    override func animationDidStart(_ anim: CAAnimation){
        animationDidStartClosure(isOn)
    }
    
    
    override func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        animationDidStopClosure(isOn, flag)
    }
}

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net 
