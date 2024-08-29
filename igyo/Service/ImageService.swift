import Foundation
import FirebaseStorage

protocol ImageServiceProtocol {
  func upload(data: Data, type: ImageService.ImageType) async throws -> URL?
  func update(fileName: String, data: Data, type: ImageService.ImageType) async throws -> URL?
  func delete(type: ImageService.ImageType) async throws
}

final class ImageService: ImageServiceProtocol {
  enum ImageType {
    case post(id: String, uid: String)
    case user(id: String)

    var path: String {
      switch self {
      case .post(let id, let uid): "posts/\(uid)/\(id).jpg"
      case .user(let id): "users/\(id)/\(id).jpg"
      }
    }
  }

  let storage: Storage
  let metadata: StorageMetadata

  init() {
    self.storage = Storage.storage()
    self.metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
  }

  func upload(data: Data, type: ImageType) async throws -> URL? {
    do {
      print("## ", type.path)
      _ = try await storage.reference().child(type.path).putDataAsync(data, metadata: metadata)
      let url: URL? = try await storage.reference().child(type.path).downloadURL()
      return url
    } catch {
      throw error
    }
  }

  func update(fileName: String, data: Data, type: ImageService.ImageType) async throws -> URL? {
    do {
      _ = try await storage.reference().child(type.path).putDataAsync(data, metadata: metadata)
      let url: URL? = try await storage.reference().child(type.path).downloadURL()
      return url
    } catch {
      throw error
    }
  }

  func delete(type: ImageService.ImageType) async throws {
    do {
      try await storage.reference().child(type.path).delete()
    } catch {
      throw error
    }
  }
}
