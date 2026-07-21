import Foundation
import CoreGraphics

// Private framework links required to expose virtual hardware bindings to System Settings
@_silgen_name("CGVirtualDisplayModeCreate")
func CGVirtualDisplayModeCreate(_ width: UInt32, _ height: UInt32, _ refreshRate: Double, _ unknown: UInt32) -> AnyObject?

@_silgen_name("CGVirtualDisplaySettingsCreate")
func CGVirtualDisplaySettingsCreate() -> AnyObject?

@_silgen_name("CGVirtualDisplaySettingsSetModes")
func CGVirtualDisplaySettingsSetModes(_ settings: AnyObject, _ modes: CFArray)

@_silgen_name("CGVirtualDisplayCreate")
func CGVirtualDisplayCreate(_ settings: AnyObject, _ unknown: UnsafeMutablePointer<UInt32>?, _ queue: DispatchQueue) -> AnyObject?

class Virtual360HzDisplay {
    private var displayDescriptor: AnyObject?
    private let targetQueue = DispatchQueue(label: "com.opiumhz.display.queue", qos: .userInteractive)

    func initializeVirtualDriver() {
        print("[...] Initializing 360Hz display descriptors...")
        
        // 1. Build the custom hardware mode timing table (1920x1080 @ 360.0 Hz)
        guard let custom360HzMode = CGVirtualDisplayModeCreate(1920, 1080, 360.0, 0) else {
            print("✖ Critical Failure: Unable to allocate virtual video timings.")
            exit(1)
        }

        // 2. Wrap the timing mode inside a CoreGraphics system setting array
        guard let driverSettings = CGVirtualDisplaySettingsCreate() else {
            print("✖ Critical Failure: CoreGraphics refused device settings creation.")
            exit(1)
        }

        let modePipelineArray: [AnyObject] = [custom360HzMode]
        CGVirtualDisplaySettingsSetModes(driverSettings, modePipelineArray as CFArray)

        // 3. Register the virtual display driver to System Settings
        targetQueue.async {
            var assignedIndex: UInt32 = 0
            self.displayDescriptor = CGVirtualDisplayCreate(driverSettings, &assignedIndex, self.targetQueue)
            
            if self.displayDescriptor != nil {
                print("✔ Virtual Display successfully registered to System Settings -> Displays!")
                print("➜ Performance State: 1920x1080 @ 360Hz Unconstrained Monitor Active.")
            } else {
                print("✖ Security Refusal: Code lacks the required system capabilities to handle display frames.")
                exit(1)
            }
        }
    }
}

// Instantiate and hold the driver alive in execution memory
let driverEngine = Virtual360HzDisplay()
driverEngine.initializeVirtualDriver()

// Keep the background daemon loop running indefinitely
RunLoop.main.run()