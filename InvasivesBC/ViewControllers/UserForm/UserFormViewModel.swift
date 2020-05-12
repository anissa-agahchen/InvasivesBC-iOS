//
//  UserFormViewModel.swift
//  InvasivesBC
//
//  Created by Pushan  on 2020-05-12.
//  Copyright © 2020 Amir Shayegh. All rights reserved.
//

import Foundation
class UserFormViewModel: FormModel<User> {
    override var layout: Layout {
        var layout: Layout = Layout()
        var group: Layout.Group = Layout.Group()
        group.header = "User Fields"
        group.fields = [
            ("firstName", .Half),
            ("lastName", .Half),
            ("email", .Half)
        ]
        layout.groups = [group]
        return layout
    }
    
    
    override class func fieldForModel(property: PropertyDescriptor, editable: Bool = true) -> Field? {
        return nil
    }
}
