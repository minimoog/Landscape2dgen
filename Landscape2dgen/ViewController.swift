//
//  ViewController.swift
//  Landscape2dgen
//
//  Created by Toni Jovanoski on 2/28/17.
//  Copyright © 2017 Antonie Jovanoski. All rights reserved.
//

import UIKit

struct Point {
    let x: Float
    let y: Float
}

extension Array {
    func sample() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        
        return self[index]
    }
}

func midPointDisplacement(start: Point, end: Point, roughtness: Float, verticalDisplacement: Float = 0.0, numOfIterations: Int = 16) -> [Point] {
    var vd = verticalDisplacement
    
    if verticalDisplacement == 0.0 {
        vd = (start.y + end.y) / 2.0
    }
    
    var points = [start, end]
    
    var iteration = 1
    
    while iteration <= numOfIterations {
        let p = points
        
        for i in 0..<p.count - 1 {
            let midpoint = Point(x: (p[i].x + p[i+1].x) / 2.0,
                                 y: (p[i].y + p[i+1].y) / 2.0)
            
            
            let dispMidpoint = Point(x: midpoint.x,
                                     y: midpoint.y + [-vd, vd].sample())
            
            points.insert(dispMidpoint, at: 2 * i + 1)
            
        }
        
        vd *= pow(2, -roughtness)
        
        iteration += 1
    }
    return points
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func drawLandscapeLayer(points: [Point], color: UIColor, width: CGFloat, height: CGFloat) {
        let path = UIBezierPath()
        color.setFill()
        
        path.move(to: CGPoint(x: CGFloat(points[0].x), y: CGFloat(points[0].y)))
        
        for i in 1..<points.count {
            path.addLine(to: CGPoint(x: CGFloat(points[i].x), y: CGFloat(points[i].y)))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        
        path.close()
        path.fill()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

