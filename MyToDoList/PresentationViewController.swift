//
//  PresentationViewController.swift
//  MyToDoList
//
//  Created by Георгий Матченко on 15.03.2022.
//

import UIKit

class PresentationViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var emoji: UILabel!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var button: UIButton!
    
    var contentLabel = ""
    var contentEmoji = ""
    var currentPage = 0
    var numberOfPages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = contentLabel
        emoji.text = contentEmoji
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = currentPage
        
        showButton()
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        closePresentation()
    }
    
    func closePresentation() {
        dismiss(animated: true, completion: nil)
    }
    
    func showButton() {
        if (numberOfPages - 1) == currentPage {
            button.isHidden = false
        } else {
            button.isHidden = true
        }
        
    }
}

