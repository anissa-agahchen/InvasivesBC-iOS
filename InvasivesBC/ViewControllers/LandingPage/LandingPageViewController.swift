//
//  LandingPageViewController.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-22.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import UIKit

// LandingPageViewController:
//  ViewController for User LandingPage / Home Screen / Dashboard
class LandingPageViewController: BaseViewController {

    
    // MARK: Variables
    // EntryOptionViewController Ref
    weak var entryOptionViewController: EntryOptionViewController?
    
    // MARK: Outlet
    
    
    // MARK: View Controller
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide Navigation Bar
        self.setNavigationBar(hidden: true, style: .default)
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigationBar(hidden: true, style: .default)
        CodeTableService.shared.download(completion: { (done) in
            print(done)
        }) { (status) in
            print(status)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Getting entry option view controller
        if segue.appSegueIdentifier == .showEntryOptions {
            // Setting entryOptionViewController variable
            self.entryOptionViewController = segue.destination as? EntryOptionViewController
            // Setting delegate to self
            self.entryOptionViewController?.delegate = self
        }
    }
    

}

extension LandingPageViewController: EntryOptionDelegate {
    func didSelect(entryOption: EntryOption) {
        // TODO: Handle option selection
        InfoLog("Get selected option: \(entryOption)")
        performSegue(withIdentifier: "showPointPicker", sender: self)
    }
}
