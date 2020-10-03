//
//  DialChartView.swift
//  AIPM-iOS
//
//  Created by Joshua Dadson on 9/29/20.
//  Copyright © 2020 Joshua Dadson. All rights reserved.
//

import UIKit

class DialChartView: UIView {
    var outerBezelColor = UIColor(displayP3Red: 0/255, green: 45/255, blue: 156/255, alpha: 1.0)
    var outerBezelWidth: CGFloat = 10
    
    var insideColor = UIColor.white
    
    var guageColor = UIColor.green
    var gaugeWidth: CGFloat = 20
    

    func drawGauge(in rect: CGRect, context ctx: CGContext) {
        outerBezelColor.set()
        ctx.fillEllipse(in: rect)
        
        let innerBezelRect = rect.insetBy(dx: outerBezelWidth, dy: outerBezelWidth)
        insideColor.set()
        ctx.fillEllipse(in: innerBezelRect)
        
    }
    var score: CGFloat {
        didSet {
            updateGauge()
        }
    }
    var type: String
    
    init(score: CGFloat, type: String) {
        self.score = score
        self.type = type
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateGauge() {
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        print("Type: \(type), Score: \(score)")
//        drawGauge(in: rect, context: ctx)
        
//        ctx.saveGState()
        UIColor.gray.set()
        ctx.translateBy(x: rect.midX, y: rect.midY)
        
        ctx.setLineWidth(15.0)
        ctx.addArc(center: .zero, radius: 40.0, startAngle: .pi, endAngle: .pi * 2, clockwise: false)
        ctx.drawPath(using: .stroke)
        
        if self.type == "Health" {
            UIColor.green.set()
            ctx.setLineWidth(10)
            ctx.addArc(center: .zero, radius: 40, startAngle: .pi, endAngle: (.pi + (.pi * score)/100), clockwise: false)
            ctx.drawPath(using: .stroke)
        } else if self.type == "Upper" {
            UIColor.green.set()
            ctx.setLineWidth(10)
            ctx.addArc(center: .zero, radius: 40, startAngle: .pi, endAngle: (.pi + (.pi * score)/2000), clockwise: false)
            ctx.drawPath(using: .stroke)
        } else if self.type == "Middle" {
            UIColor.green.set()
            ctx.setLineWidth(10)
            ctx.addArc(center: .zero, radius: 40, startAngle: .pi, endAngle: (.pi + (.pi * score)/5000), clockwise: false)
            ctx.drawPath(using: .stroke)
        } else if self.type == "Lower" {
            UIColor.green.set()
            ctx.setLineWidth(10)
            ctx.addArc(center: .zero, radius: 40, startAngle: .pi, endAngle: (.pi + (.pi * score)/5000), clockwise: false)
            ctx.drawPath(using: .stroke)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
