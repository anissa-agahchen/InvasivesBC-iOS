//
//  FormCollectionViewController.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-05-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


// MARK: FormGroupCellType
/// Collection of different FormGroup Cell type
class FormGroupCellType: NSString, CaseIterable {
    /// Basic Cell Types
    static let BasicFormGroupCell: FormGroupCellType = "FormGroupCollectionViewCell"
    
    /// Collection of different cell types. If we require to include any custom group, then create a cell type subclass and override this method by including nib name in the array
    static var allCellTypes: [FormGroupCellType] {
        return [ BasicFormGroupCell ]
    }
    
    // MARK: CaseIterable
    static var allCases: [FormGroupCellType] {
        // All cell types associated with Class
        var allCells = Self.allCellTypes
        // Checking basic cells is added or not
        if allCellTypes.filter({ $0 == BasicFormGroupCell }).count == 0 {
            allCells.append(BasicFormGroupCell)
        }
        return allCells
    }
}

// MARK: Extension UICollectionView
/// Extending collection view class to support FormGroupCell type
extension UICollectionView {
    
    /// Returning FormGroup Cell type
    func dequeueReusableFormGroupCell(withType type: FormGroupCellType, for indexPath: IndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: type as String, for: indexPath)
    }
    
    /// Register FormGroupCellType nib with Nib name as Identifier
    func register(formGroupCell: FormGroupCellType) {
        let nib = UINib(nibName: formGroupCell as String, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: formGroupCell as String)
    }
}

/// CollectionView to display Form for Connected Model and ViewModel
class FormCollectionViewController<Model: BaseObject, CellType: FormGroupCellType>: UICollectionViewController {
   
    // MARK: ViewModel
    typealias ViewModel = FormModel<Model>
    
    /// Property ViewModel
    var formModel: ViewModel?
    
    
    // MARK: UIViewController
    override func viewDidLoad() {
        // Super Call
        super.viewDidLoad()
        
        // Register associated cell types
        self.registerCellType()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.formModel?.groups.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

// MARK: UICollectionView
/// Extending or modularising FormCollectionViewController functionality
extension FormCollectionViewController {
    /// Registering associated cell types
    func registerCellType() {
        for cellType in CellType.allCellTypes {
            self.collectionView?.register(formGroupCell: cellType)
        }
    }
}
