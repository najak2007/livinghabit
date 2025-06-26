//
//  CaptureManager.swift
//  livinghabit
//
//  Created by najak on 6/26/25.
//

import SwiftUI
import AVFoundation

class CaptureManager: NSObject {
    static let instance = CaptureManager()
    
    private override init() {}
    
    func requestCameraPermission(permissionResult: @escaping(Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                permissionResult(true)
            } else {
                permissionResult(false)
                print("카메라 권한 거부")
            }
        }
    }
}
