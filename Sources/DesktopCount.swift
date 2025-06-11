import Cocoa

// Private CoreGraphics functions to inspect Spaces
private typealias CGSConnection = UInt32

@_silgen_name("_CGSDefaultConnection")
fileprivate func _CGSDefaultConnection() -> CGSConnection

@_silgen_name("CGSCopyManagedDisplaySpaces")
fileprivate func CGSCopyManagedDisplaySpaces(_ conn: CGSConnection) -> CFArray

@_silgen_name("CGSCopyActiveMenuBarSpace")
fileprivate func CGSCopyActiveMenuBarSpace(_ conn: CGSConnection) -> UInt64

/// Determine the index of the currently active Space (1-based).
fileprivate func currentSpaceIndex() -> Int {
    let conn = _CGSDefaultConnection()
    guard let displays = CGSCopyManagedDisplaySpaces(conn) as? [[String: Any]] else {
        return 0
    }
    let activeSpace = CGSCopyActiveMenuBarSpace(conn)
    for display in displays {
        if let spaces = display["Spaces"] as? [[String: Any]] {
            for (idx, space) in spaces.enumerated() {
                if let sid = space["id64"] as? UInt64, sid == activeSpace {
                    return idx + 1
                }
            }
        }
    }
    return 0
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        update()
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(spaceChanged),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil)
    }

    @objc func spaceChanged(_ note: Notification) {
        update()
    }

    private func update() {
        statusItem.button?.title = "\(currentSpaceIndex())"
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
