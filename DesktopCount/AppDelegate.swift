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
    var timer: Timer?
    let yabaiPaths = ["/opt/homebrew/bin/yabai", "/usr/local/bin/yabai"]

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        update()
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(spaceChanged),
            name: NSWorkspace.activeSpaceDidChangeNotification,
            object: nil)
        // Also poll every 2 seconds in case of missed events
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.update()
        }
    }

    @objc func spaceChanged(_ note: Notification) {
        update()
    }

    private func update() {
        guard let yabaiPath = yabaiPaths.first(where: { FileManager.default.isExecutableFile(atPath: $0) }) else {
            statusItem.button?.title = "?"
            return
        }
        let task = Process()
        let pipe = Pipe()
        task.launchPath = yabaiPath
        task.arguments = ["-m", "query", "--spaces"]
        task.standardOutput = pipe
        task.standardError = nil
        do {
            try task.run()
        } catch {
            statusItem.button?.title = "?"
            return
        }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            statusItem.button?.title = "?"
            return
        }
        if let focused = json.first(where: { ($0["has-focus"] as? Bool) == true }),
           let index = focused["index"] as? Int {
            statusItem.button?.title = "\(index)"
        } else {
            statusItem.button?.title = "?"
        }
    }
} 