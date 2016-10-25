//
//  GCDBlackBOX.swift
//  OnTheMap
//
//  Created by Ranjith on 8/29/16.
//  Copyright © 2016 Ranjith. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}