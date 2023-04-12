//  scr33nsav3r by Alpha King of a3ther

import ScreenSaver
import SwiftUI

//let urlString = "https://16colo.rs/pack/acid-100/x2/LD-RIP.ANS.png"

class scr33nsav3rView: ScreenSaverView {
    // Properties for ANSi image and its position
    private var image: NSImage?
    private var position: CGFloat = 0
    private var direction: CGFloat = 1
    private var currentOffset: CGFloat = 0
    private var maxOffset: CGFloat = 0
    private var currentImage: NSImage?
    private let defaults = UserDefaults.init(suiteName: "wtf.a3ther.scr33nsav3r")!
    private let viewModel = SettingsViewModel()
    lazy var sheetController: ConfigureSheetController = {
        let settingsViewModel = SettingsViewModel()
        return ConfigureSheetController(viewModel: settingsViewModel)
    }()
    
    override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        // Set the animation time interval
        //animationTimeInterval = 1 / 30.0
        loadImage()
        sheetController.viewModel.onAnimationSpeedIndexChanged = { [weak self] in
            self?.updateAnimationTimeInterval()
        }
        updateAnimationTimeInterval()
    }
    
    override public var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.isReleasedWhenClosed = false
        window.contentView = NSHostingView(rootView: ConfigureSheetView(viewModel: SettingsViewModel()))
        return window
    }
    
    private func loadImage() {
        guard let urlString = sheetController.viewModel.randomSelectedArtistURL,
              let imageURL = URL(string: urlString) else { return }
        let downloadTask = URLSession.shared.dataTask(with: imageURL) { [weak self] (data, response, error) in
            guard let data = data, let downloadedImage = NSImage(data: data), error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.image = downloadedImage
                if let imageSize = self?.image?.size, let screenHeight = self?.bounds.height {
                    // Updated position calculation to start at the top of the screen
                    self?.position = screenHeight - imageSize.height
                }
                self?.setNeedsDisplay(self?.bounds ?? .zero)
            }
        }
        downloadTask.resume()
    }
    
    private func updateAnimationTimeInterval() {
        let animationSpeeds: [TimeInterval] = [0.2, 0.1, 0.05, 0.025]
        let index = sheetController.viewModel.animationSpeedIndex
        self.animationTimeInterval = animationSpeeds[index]
    }
    
    override func draw(_ rect: NSRect) {
        super.draw(rect)
        
        if let image = self.image {
            let aspectRatio = image.size.width / image.size.height
            let targetHeight = rect.width / aspectRatio
            let targetWidth = rect.width
            let targetRect = NSRect(x: 0, y: position, width: targetWidth, height: targetHeight)
            NSGraphicsContext.current?.imageInterpolation = .none
            image.draw(in: targetRect)
        }
    }
    
    // Add an enum to handle the animation state
    enum AnimationState {
        case scrolling
        case paused
    }
    
    private var animationState: AnimationState = .paused
    private var pauseStartTime: TimeInterval = 0
    private let pauseDuration: TimeInterval = 3
    
    override func animateOneFrame() {
        switch animationState {
        case .scrolling:
            guard let image = self.image else { return }
            let screenHeight = bounds.height
            let maxScroll = image.size.height - screenHeight
            
            position += direction
            
            if position <= -maxScroll || position >= 0 {
                animationState = .paused
                pauseStartTime = NSDate().timeIntervalSinceReferenceDate
                
                // Reverse the scrolling direction when the bottom or top is reached
                direction = -direction
            }
            
            setNeedsDisplay(bounds)
            
        case .paused:
            let elapsedTime = NSDate().timeIntervalSinceReferenceDate - pauseStartTime
            if elapsedTime >= pauseDuration {
                animationState = .scrolling
            }
        }
    }
}

// ConfigureSheetController for handling configuration sheet
class ConfigureSheetController: NSObject, NSWindowDelegate {
    @ObservedObject var viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
    }
    
    var window: NSWindow {
        let contentView = ConfigureSheetView(viewModel: viewModel)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 600),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.center()
        window.title = "Configure scr33nsav3r"
        window.contentView = NSHostingView(rootView: contentView)
        window.delegate = self
        return window
    }
    
    func saveSettingsAndClose() {
        viewModel.saveSettings()
        window.close()
    }
    
    // When the window is closing, save settings
    func windowWillClose(_ notification: Notification) {
        viewModel.saveSettings()
        NSApp.stopModal()
    }
}
