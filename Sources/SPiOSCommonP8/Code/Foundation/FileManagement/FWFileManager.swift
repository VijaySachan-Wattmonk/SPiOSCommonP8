//
//  FWFileManager.swift
//  SPiOSCommonP8
//
//  Created by Wattmonk21 on 08/09/25.
//

import Foundation
import UIKit

/**
 A tiny, reusable file utility focused on image persistence within the iOS app sandbox.

 ### Highlights
 - **Async write**: Saves images on a background task to keep UI responsive.
 - **Result-based API**: Returns `Result<URL, FWFileManagerError>` for clear success/failure handling.
 - **Configurable target**: Choose the sandbox *directory* (e.g., `.documentDirectory`, `.cachesDirectory`) and an optional *subfolder* (auto-created).

 ### Threading
 All filesystem work for saving is dispatched via `Task.detached(priority: .userInitiated)` to avoid blocking the main thread.
 */
public final class FWFileManager:Sendable,FWLoggerDelegate{
    public static let shared = FWFileManager()
    private init(){}

    // MARK: - Errors
    /// Errors that can be returned by FWFileManager operations.
    public enum FWFileManagerError: Error {
        /// The UIImage could not be encoded to the requested format (e.g., extension unsupported or encoder failed).
        case imageEncodingFailed(String)
        /// Creating the destination folder failed.
        case folderCreationFailed(String)
        /// Writing the file to disk failed.
        case writeFailed(String)
    }

    // MARK: - Save Image (Async)
    /**
     Saves a `UIImage` to a sandbox directory **asynchronously** and returns a `Result` describing success or failure.

     The image format is inferred from `fileExtension`:
     - `.png` → Encoded using `pngData()`
     - `.jpg` / `.jpeg` → Encoded using `jpegData(compressionQuality:)`
     - Any other extension → `.failure(.imageEncodingFailed)`

     The destination directory is configurable (Documents/Caches/etc.), and you can optionally provide a subfolder. If the subfolder does not exist, it will be created automatically.

     ### Parameters
     - `image`: The source image to persist.
     - `name`: The base filename without extension (e.g., `"panel_label"`, `"thumb"`).
     - `fileExtension`: The file extension to use (e.g., `"jpg"`, `"jpeg"`, `"png"`). Defaults to `"jpg"`.
     - `inFolder`: Optional subfolder under the chosen `directory` (e.g., `"Images"`). Created if needed.
     - `directory`: A `FileManager.SearchPathDirectory` where the file should be saved. Defaults to `.documentDirectory`.
     - `compressionQuality`: JPEG compression quality (`0.0 ... 1.0`). Ignored for PNG.

     ### Returns
     A `Result<URL, FWFileManagerError>`:
     - `.success(URL)`: The fully qualified file URL where the image was saved.
     - `.failure(FWFileManagerError)`: One of:
       - `.imageEncodingFailed(String)`: Extension unsupported or encoder failed.
       - `.folderCreationFailed(String)`: Could not create the subfolder.
       - `.writeFailed(String)`: Disk write failed.

     ### Threading
     Work runs off the main thread using `Task.detached(priority: .userInitiated)`.

     ### Example
     ```swift
     let result = await FWFileManager.shared.saveImage(
         image,
         name: "panel_label",
         fileExtension: "jpg",
         inFolder: "Images",
         directory: .documentDirectory,
         compressionQuality: 0.85
     )

     switch result {
     case .success(let url):
         print("Saved to:", url.path)
     case .failure(let error):
         print("Save failed:", error)
     }
     ```
     */
    public func saveImage(_ image: UIImage,
                          name: String,
                          fileExtension: String = "jpg",
                          inFolder: String? = nil,
                          directory: FileManager.SearchPathDirectory = .documentDirectory,
                          compressionQuality: CGFloat = 0.85) async -> Result<URL, FWFileManagerError> {
        return await Task.detached(priority: .userInitiated) { () -> Result<URL, FWFileManagerError> in
            // Determine data encoder based on file extension
            let ext = fileExtension.lowercased()
            let data: Data?
            if ext == "png" {
                data = image.pngData()
            } else if ext == "jpg" || ext == "jpeg" {
                data = image.jpegData(compressionQuality: compressionQuality)
            } else {
                let msg="Unsupported file extension '\(fileExtension)'."
                self.mLog(msg: msg)
                return .failure(.imageEncodingFailed(msg))
            }
            guard let data else {
                let msg="Failed to encode image for '\(name).\(ext)'."
                return .failure(.imageEncodingFailed(msg))
            }
            let finalName = name + "." + ext
            // Resolve base directory
            var dirURL = FileManager.default.urls(for: directory, in: .userDomainMask)[0]

            // Optionally create subfolder
            if let folder = inFolder, !folder.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                dirURL = dirURL.appendingPathComponent(folder, isDirectory: true)
                do {
                    try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: true)
                } catch {
                    return .failure(.folderCreationFailed(error.localizedDescription))
                }
            }
            // Compose destination file URL and write atomically
            let fileURL = dirURL.appendingPathComponent(finalName)
            do {
                try data.write(to: fileURL, options: .atomic)
                self.mLog(msg: "Successfully saved image \(finalName)")
                return .success(fileURL)
            } catch {
                self.mLog(msg: "Failed to save image \(error.localizedDescription)")
                return .failure(.writeFailed(error.localizedDescription))
            }
        }.value
    }

    /**
     Fetches a `UIImage` from the sandbox directory **asynchronously** and returns a `Result` describing success or failure.

     The image format is inferred from `fileExtension`:
     - `.png`, `.jpg`, `.jpeg` are supported.
     - Any other extension results in `.failure(.imageEncodingFailed)`.

     The file is searched for in the specified `directory` and optional `inFolder`. If the image file exists and can be loaded, it returns `.success(UIImage)`.
     Otherwise, it returns `.failure(FWFileManagerError)` indicating the failure reason.

     ### Parameters
     - `name`: The base filename without extension (e.g., `"panel_label"`, `"thumb"`).
     - `fileExtension`: The file extension to use (e.g., `"jpg"`, `"jpeg"`, `"png"`). Defaults to `"jpg"`.
     - `inFolder`: Optional subfolder under the chosen `directory` (e.g., `"Images"`).
     - `directory`: A `FileManager.SearchPathDirectory` where the file should be read from. Defaults to `.documentDirectory`.

     ### Returns
     A `Result<UIImage, FWFileManagerError>`:
     - `.success(UIImage)`: The loaded image.
     - `.failure(FWFileManagerError)`: One of:
       - `.imageEncodingFailed(String)`: Extension unsupported.
       - `.writeFailed(String)`: File not found or could not be loaded.

     ### Threading
     Work runs off the main thread using `Task.detached(priority: .userInitiated)`.

     ### Example
     ```swift
     let result = await FWFileManager.shared.fetchImage(
         name: "panel_label",
         fileExtension: "jpg",
         inFolder: "Images",
         directory: .documentDirectory
     )

     switch result {
     case .success(let image):
         print("Loaded image successfully")
     case .failure(let error):
         print("Load failed:", error)
     }
     ```
     */
    public func fetchImage(name: String,
                           fileExtension: String = "jpg",
                           inFolder: String? = nil,
                           directory: FileManager.SearchPathDirectory) async -> Result<UIImage, FWFileManagerError> {
        return await Task.detached(priority: .userInitiated) { () -> Result<UIImage, FWFileManagerError> in
            let ext = fileExtension.lowercased()
            guard ext == "png" || ext == "jpg" || ext == "jpeg" else {
                let msg = "Unsupported file extension '\(fileExtension)'."
                self.mLog(msg: msg)
                return .failure(.imageEncodingFailed(msg))
            }
            var dirURL = FileManager.default.urls(for: directory, in: .userDomainMask)[0]
            if let folder = inFolder, !folder.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                dirURL = dirURL.appendingPathComponent(folder, isDirectory: true)
            }
            let fileURL = dirURL.appendingPathComponent(name + "." + ext)
            guard FileManager.default.fileExists(atPath: fileURL.path) else {
                let msg = "File does not exist at path: \(fileURL.path)"
                self.mLog(msg: msg)
                return .failure(.writeFailed(msg))
            }
            guard let data = try? Data(contentsOf: fileURL),
                  let image = UIImage(data: data) else {
                let msg = "Failed to load image from file: \(fileURL.path)"
                self.mLog(msg: msg)
                return .failure(.writeFailed(msg))
            }
            self.mLog(msg: "Successfully fetched image for file name: \(name).\(fileExtension)")
            return .success(image)
        }.value
    }
    
}
