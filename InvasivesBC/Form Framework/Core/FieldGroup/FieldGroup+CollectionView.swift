//
//  FieldGroup+CollectionView.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-04-08.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
import UIKit

// Supporting Form Cell for CollectionView
extension UICollectionView {
    
    // Generic method to obtain FieldCell
    func dequeueReusableFieldCell(type: FieldGroupView.FieldCellType, for index: IndexPath) -> FieldCell {
        return self.dequeueReusableCell(withFieldType: type, for: index) as! FieldCell
    }
    
    // Method to obtain TextFieldType
    func dequeueReusableTextFieldCell(for indexPath: IndexPath) -> TextFieldCollectionViewCell {
        return self.dequeueReusableFieldCell(type: .text, for: indexPath) as! TextFieldCollectionViewCell
    }
}

// CollectionView related extension of FieldGroup View
extension FieldGroupView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    // No of Item in section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fields.count
    }
    
    // Cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let config = fields[indexPath.row]
        let cell = collectionView.dequeueReusableFieldCell(type: config.fieldCellType, for: indexPath)
        cell.initialize(model: config, presenter: self.presenter)
       return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    // Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           let assumedCellSpacing: CGFloat = 10
           var cellSpacing = assumedCellSpacing
           let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
           if let layoutUnwrapped = layout {
               cellSpacing = layoutUnwrapped.minimumInteritemSpacing
           }
           
           var previousItemWidth: FieldWidthClass? = nil
           
           if indexPath.row >= 1 {
               let previous = fields[indexPath.row - 1]
               previousItemWidth = previous.width
           }
           
           let item = fields[indexPath.row]
           let containerWidth = collectionView.frame.width
           var multiplier: CGFloat = 1
           switch item.width {
           case .Full:
               return CGSize(width: containerWidth, height: item.height)
           case .Half:
               multiplier = 2
           case .Third:
               multiplier = 3
           case .Forth:
               multiplier = 4
           case .Fill:
               if let previousWidth = previousItemWidth {
                   switch previousWidth {
                   case .Full:
                       return CGSize(width: containerWidth, height: item.height)
                   case .Half:
                       multiplier = 2
                   case .Third:
                       multiplier = 3
                   case .Forth:
                       multiplier = 4
                   case .Fill:
                       return CGSize(width: containerWidth, height: item.height)
                   }
               } else {
                   return CGSize(width: containerWidth, height: item.height)
               }
           }
           
           return CGSize(width: (containerWidth - (multiplier * cellSpacing)) / multiplier, height: item.height)
       }
    
}
