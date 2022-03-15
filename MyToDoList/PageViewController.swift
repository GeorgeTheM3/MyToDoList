//
//  PageViewController.swift
//  MyToDoList
//
//  Created by Георгий Матченко on 15.03.2022.
//

import UIKit

class PageViewController: UIPageViewController {
    
    let presentScreenContent = [
    "Чтобы добавить новую задачу нажмите + в правом верхнем углу",
    "Пометить задачу как выполненную можно кликнув по строке",
    "Для снятия отметки кликните повторно",
    "Удаление осуществляется путём свайпа строки влево",
    "Приятного пользования!"
    ]

    let emojiArray = ["🌑","🌘","🌗","🌖","🌕"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let presentViewController = showViewControllerAtIndex(0){
            setViewControllers([presentViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func showViewControllerAtIndex (_ index: Int) -> PresentationViewController? {
        guard index >= 0 else { return nil}
        guard index < presentScreenContent.count else {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "PresentetionWasViewed")
            return nil }
        guard let presentViewController = storyboard?.instantiateViewController(
            withIdentifier: "PresentationView") as? PresentationViewController else { return nil }
        
        presentViewController.contentLabel = presentScreenContent[index]
        presentViewController.contentEmoji = emojiArray[index]
        presentViewController.currentPage = index
        presentViewController.numberOfPages = presentScreenContent.count
        
        return presentViewController
    }
}
