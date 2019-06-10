//
//  DrawingViewController.swift
//  Sketchpad
//
//  Created by Ricardo Hui on 10/6/2019.
//  Copyright © 2019 Ricardo Hui. All rights reserved.
//

import UIKit
import ChromaColorPicker

class DrawingViewController: UIViewController, ChromaColorPickerDelegate {

    
    @IBOutlet var imageView: UIImageView!
    var lastPoint : CGPoint = CGPoint(x: 0 ,y: 0)
    var currentColor = UIColor.blue.cgColor
    var brushSize : Float = 30.0
    var colorPicker : ChromaColorPicker?
    var greyedOut = UIView()
    
    @IBOutlet var stackView: UIStackView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        greyedOut = UIView(frame: view.frame)
        greyedOut.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(greyedOut)
        colorPicker = ChromaColorPicker(frame: CGRect(x: view.frame.size.width / 2 - 100, y: view.frame.size.height / 2 - 100, width: 200, height: 200))
        // Do any additional setup after loading the view.
        if let picker = colorPicker{
            picker.delegate = self
            picker.padding = 5
            picker.stroke = 3
            picker.hexLabel.isHidden = true
            view.addSubview(picker)
        }
        greyedOut.isHidden = true
         colorPicker?.isHidden = true
    }
    
    
    @IBAction func deleteTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Name your picture", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in textField.placeholder = "My Masterpiece"}
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) in
            if let name = ac.textFields?.first?.text{
                if name != ""{
                    if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext{
                        let picture = Picture(context: context)
                        picture.name = name
                        if let image = self.imageView.image{
                            picture.image = image.jpegData(compressionQuality: 1)
                            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                        }
                    }
                  self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
            
        }
        
        ac.addAction(cancelAction)
        ac.addAction(saveAction)
        present(ac, animated: true, completion: nil)
        
        
    }
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        print("Color chosen!")
        currentColor = color.cgColor
        colorPicker.isHidden = true
         greyedOut.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        stackView.isHidden = true
        if let beginPoint = touches.first?.location(in: imageView){
            lastPoint  = beginPoint
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let movedPoint = touches.first?.location(in: imageView){
            drawBetweenTwoPoints(point1: lastPoint, point2: movedPoint)
            lastPoint = movedPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        stackView.isHidden = false
        if let endPoint = touches.first?.location(in: imageView){
            drawBetweenTwoPoints(point1: lastPoint, point2: endPoint)
           
        }
    }
    
    func drawBetweenTwoPoints(point1: CGPoint, point2: CGPoint){
        UIGraphicsBeginImageContext(imageView.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: imageView.frame.width, height: imageView.frame.height))
        if let context = UIGraphicsGetCurrentContext(){
            context.move(to: point1)
            context.addLine(to: point2)
            context.setLineWidth(CGFloat(brushSize) / 3.0)
            context.setLineCap(.round)
            context.setStrokeColor(currentColor)
            context.strokePath()
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
    }
    
    @IBAction func colorTapped(_ sender: Any) {
        colorPicker?.adjustToColor(UIColor(cgColor: currentColor))
         colorPicker?.isHidden = false
         greyedOut.isHidden = false
    }
    
    @IBAction func sizeTapped(_ sender: Any) {
        let ac =  UIAlertController(title: "Brush Size", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        let slider = UISlider(frame: CGRect(x: 10, y: 50, width: 250, height: 80))
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.value = brushSize
        ac.view.addSubview(slider)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            self.brushSize = slider.value
        }
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    @IBAction func eraseTapped(_ sender: Any) {
        currentColor = UIColor.white.cgColor
    }
    
}
