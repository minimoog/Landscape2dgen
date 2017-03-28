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

extension Int {
    func random() -> Int {
        let randomNumber = Int(arc4random_uniform(UInt32(self)))
        
        return randomNumber
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
    
    let colorDict: [Int: UIColor] = [0: UIColor(red: 195/255, green: 157/255, blue: 224/255, alpha: 1),
                                     1: UIColor(red: 158/255, green:  98/255, blue: 204/255, alpha: 1),
                                     2: UIColor(red: 130/255, green:  79/255, blue: 138/255, alpha: 1),
                                     3: UIColor(red:  68/255, green:  28/255, blue:  99/255, alpha: 1),
                                     4: UIColor(red:  49/255, green:   7/255, blue:  82/255, alpha: 1),
                                     5: UIColor(red:  23/255, green:   3/255, blue:  38/255, alpha: 1),
                                     6: UIColor(red: 240/255, green: 203/255, blue: 163/255, alpha: 1)]
    
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onRegenerate(_ sender: UIButton) {
        drawLandscape()
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        guard let image = imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageOnSave(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func imageOnSave(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "The image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
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
    
    func drawLandscape() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: imageView.frame.width, height: imageView.frame.height))
        
        let img = renderer.image { //[weak self]
            _ in
            let width = self.imageView.frame.width
            let height = self.imageView.frame.height
            
            let backgroundColor = self.colorDict[6]
            backgroundColor?.setFill()
            
            let background = UIBezierPath()
            background.move(to: CGPoint(x: 0, y: 0))
            background.addLine(to: CGPoint(x: width, y: 0))
            background.addLine(to: CGPoint(x: width, y: height))
            background.addLine(to: CGPoint(x: 0, y: height))
            background.close()
            background.fill()
            
            let layer1height = Int(1 / 5 * height)
            let layer2height = Int(2 / 5 * height)
            let layer3height = Int(3 / 5 * height)
            let layer4height = Int(4 / 5 * height)
            
            let layer1 = midPointDisplacement(start: Point(x: 0, y: Float(layer1height + 20.random() - 10)),
                                              end: Point(x: Float(width), y: Float(layer1height + 20.random() - 10)),
                                              roughtness: 0.9,
                                              verticalDisplacement: 80,
                                              numOfIterations: 9)
            
            let layer2 = midPointDisplacement(start: Point(x: 0, y: Float(layer2height + 20.random() - 10)),
                                              end: Point(x: Float(width), y: Float(layer2height + 20.random() - 10)),
                                              roughtness: 1.0,
                                              verticalDisplacement: 60,
                                              numOfIterations: 9)
            
            let layer3 = midPointDisplacement(start: Point(x: 0, y: Float(layer3height + 20.random() - 10)),
                                              end: Point(x: Float(width), y: Float(layer3height + 20.random() - 10)),
                                              roughtness: 1.2,
                                              verticalDisplacement: 30,
                                              numOfIterations: 8)
            
            let layer4 = midPointDisplacement(start: Point(x: 0, y: Float(layer4height + 20.random() - 10)),
                                              end: Point(x: Float(width), y: Float(layer4height + 20.random() - 10)),
                                              roughtness: 1.4,
                                              verticalDisplacement: 20,
                                              numOfIterations: 8)
            
            let layers = [layer1, layer2, layer3, layer4]
            
            for (i, layer) in layers.enumerated() {
                self.drawLandscapeLayer(points: layer, color: (self.colorDict[i]!), width: width, height: height)
            }
        }
        
        imageView.image = img
    }
    
    override func viewDidLayoutSubviews() {
        drawLandscape()
    }
}

