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
class FormGroupCellType: CaseIterable, ExpressibleByStringLiteral, Equatable, RawRepresentable {
    
    /// RawValue
    typealias RawValue = String
    
    
    /// String Type Alias
    public typealias StringLiteralType = String
    
    /// Raw Value
    fileprivate var _internalValue: String = "";
    
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
    
    // MARK: Constructor
    /// General construction
    init(_ value: String) {
        self._internalValue = value
    }
    
    /// ExpressibleByStringLiteral
    required init(stringLiteral value: StringLiteralType) {
        self._internalValue = value
    }
    
    /// RawRepresentable
    required init?(rawValue: String) {
        self._internalValue = rawValue
    }
    
    // MARK: Operator
    public static func == (lhs: FormGroupCellType, rhs: FormGroupCellType) -> Bool {
        return lhs._internalValue == rhs._internalValue
    }
    
    // MARK: Getter
    var rawValue: String {
        return self._internalValue
    }
    
}

// MARK: Extension UICollectionView
/// Extending collection view class to support FormGroupCell type
extension UICollectionView {
    
    /// Returning FormGroup Cell type
    func dequeueReusableFormGroupCell(withType type: FormGroupCellType, for indexPath: IndexPath) -> UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: type.rawValue, for: indexPath)
    }
    
    /// Register FormGroupCellType nib with Nib name as Identifier
    func register(formGroupCell: FormGroupCellType) {
        let nib = UINib(nibName: formGroupCell.rawValue, bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: formGroupCell.rawValue)
    }
}

/// CollectionView to display Form for Connected Model and ViewModel
class FormCollectionViewController<Model: BaseObject, CellType: FormGroupCellType, ViewModel: FormModel<Model>>: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    /// Property ViewModel
    var formModel: ViewModel? {
        didSet {
            self.formModel?.createFields()
            self.collectionView?.reloadData()
        }
    }
    
    /// Property Model
    var data: Model? {
        didSet {
            self.formModel?.data = self.data
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    /// Presenter delegate
    var auxViewPresenter: FieldAuxViewPresenterDelegate?
    
    
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
        
        // Get cell type from data
        guard let group: FormModel<Model>.FieldGroup = self.formModel?.groups[indexPath.row] else {
            return collectionView.dequeueReusableFormGroupCell(withType: .BasicFormGroupCell, for: indexPath)
        }
        
        // Get Cell
        let cell = collectionView.dequeueReusableFormGroupCell(withType: group.cellType, for: indexPath)
        
        // Configure Cell
        if let baseCell: BaseFormGroupCell = cell as? BaseFormGroupCell {
            baseCell.setup(fields: group.fields, with: group.header, presenter: self.auxViewPresenter)
        }
    
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
    
    // MARK: UICollectionViewDelegateFlowLayout
    /// Get Size of each form-group
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let group: FormModel<Model>.FieldGroup = self.formModel?.groups[indexPath.row] else {
            return CGSize.zero
        }
        return CGSize(width: self.collectionView!.frame.width, height: group.contentHeight)
    }
    
    // MARK: Clear
    func clear() {
        self.formModel?.clear()
    }
    
    // MARK: Destroy
    deinit {
        self.clear()
        DebugLog("\(self)")
    }
    

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




