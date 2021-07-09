//
//  Coordinator.swift
//  vibro
//
//  Created by Alex Gurbo on 9/16/20.
//  Copyright © 2020 Alex Gurbo. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
