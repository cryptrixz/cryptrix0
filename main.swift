import AppKit
import Foundation

class InstallerWindow: NSWindow, NSApplicationDelegate {
    private var driverProcess: Process?

    init() {
        let style: NSWindow.StyleMask = [.titled, .closable, .miniaturizable]
        super.init(contentRect: NSRect(x: 0, y: 0, width: 480, height: 320), styleMask: style, backing: .buffered, defer: false)
        self.title = "Opium-Hz Framework Deployment Matrix"
        self.center()
        self.makeKeyAndOrderFront(nil)
        
        setupInterface()
        launchVirtualDisplayDriver()
    }
    
    private func setupInterface() {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 480, height: 320))
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(red: 0.05, green: 0.05, blue: 0.07, alpha: 1.0).cgColor
        
        let label = NSTextField(labelWithString: "=[ Opium-Hz Engine (Virtual Workspace) ]=")
        label.frame = NSRect(x: 40, y: 240, width: 400, height: 30)
        label.font = NSFont.boldSystemFont(ofSize: 18)
        label.textColor = NSColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        view.addSubview(label)
        
        self.contentView = view
    }

    private func launchVirtualDisplayDriver() {
        print("[...] Initializing background task thread for virtual display integration...")
        
        let process = Process()
        // Resolves path inside compiled application framework directory bundle structures
        let mainBundleURL = Bundle.main.bundleURL
        let driverURL = mainBundleURL.appendingPathComponent("Contents/MacOS/opium_display_driver")
        
        process.executableURL = driverURL
        
        do {
            try process.run()
            self.driverProcess = process
            print("✔ Background display process engine successfully running.")
        } catch {
            print("✖ Critical Failure: Failed to run background display daemon binary.")
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Safe lifecycle validation tracking to stop ghost tasks running on system exit
        if let process = driverProcess, process.isRunning {
            process.terminate()
            print("✔ Safely decoupled background display driver instance context loop.")
        }
    }
}

let app = NSApplication.shared
let delegate = InstallerWindow()
app.delegate = delegate
app.run()