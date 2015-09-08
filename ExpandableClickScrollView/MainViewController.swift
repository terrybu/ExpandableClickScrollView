//
//  MainViewController.swift
//  ExpandableClickScrollView
//
//  Created by Terry Bu on 9/8/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ExpandableAboutBarDelegate {
    
    @IBOutlet weak var expandableClickScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    @IBOutlet var expandableAboutBar: ExpandableAboutBar!
    var hiddenExpandingView: UIView!
    @IBOutlet var tableview: UITableView!
    
    //MARK: Constraints
    @IBOutlet weak var constraintBarToTableviewVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var constraintContentViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeLineMarkers()
        // Do any additional setup after loading the view, typically from a nib.
        expandableAboutBar.delegate = self
    }
    
    private func placeLineMarkers() {
        for var i = 0.0; i <= Double(contentView.frame.size.height); i = i + 100 {
            let label = UILabel(frame: CGRect(x: Double(8), y: i, width: 100, height: 25))
            label.text = String(format:"%f", i)
            let line = UIView(frame: CGRect(x: Double(0), y: i, width: Double(self.view.frame.size.width), height: 1))
            line.backgroundColor = UIColor.blackColor()
            label.alpha = 0.2
            line.alpha = 0.2
            
            contentView.addSubview(label)
            contentView.addSubview(line)
        }
    }
    
    //MARK: ExpandableAboutBar methods
    func didPressExpandButton() {
        if !expandableAboutBar.expanded {
            println("did press expand button when it wasn't expanded")
            println("bar height \(expandableAboutBar.frame.size.height)")
            println("bar y \(expandableAboutBar.frame.origin.y)")
            println("tableview y \(tableview.frame.origin.y)")

            hiddenExpandingView = ExpandingAboutView(frame: CGRectMake(0, 48, self.view.frame.width, 0), titleString: "test", introductionText: "test")
            hiddenExpandingView.clipsToBounds = true
            hiddenExpandingView.backgroundColor = UIColor.redColor()
            
            self.contentView.addSubview(hiddenExpandingView)
//            hiddenExpandingView.backgroundColor = UIColor.whiteColor()
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                var newContentViewFrame = self.contentView.frame
                newContentViewFrame.size.height += 200
                self.contentView.frame = newContentViewFrame
                self.expandableClickScrollView.frame.size.height += 200
                
                var newFrame = self.hiddenExpandingView.frame
                newFrame.size.height += 200
                self.hiddenExpandingView.frame = newFrame

                self.constraintBarToTableviewVerticalConstraint.constant += 200
                self.constraintContentViewHeight.constant += 200
                
                self.view.layoutIfNeeded()

                }) { (Bool completed) -> Void in
                    self.expandableAboutBar.expanded = true
            }
        }
        else {
            println("did press expand button when it WAS expanded")
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                
                //content view
//                var newContentViewFrame = self.contentView.frame
//                newContentViewFrame.size.height -= 200
//                self.contentView.frame = newContentViewFrame
                
                var newFrame = self.hiddenExpandingView.frame
                newFrame.size.height = 0
                self.hiddenExpandingView.frame = newFrame
                
                //tableview needs to move up now 200 pixels
                self.constraintBarToTableviewVerticalConstraint.constant -= 200
                self.constraintContentViewHeight.constant -= 200
                self.view.layoutIfNeeded()
                
                }) { (Bool completed) -> Void in
                    self.expandableAboutBar.expanded = false
            }
        }
    }
    
    
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = "testcell"
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

