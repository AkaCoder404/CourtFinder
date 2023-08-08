// Constants for Appwrite
class AppwriteConstants {
  static const String databaseId = 'default';
  static const String projectId = '6454d675913037647095';
  static const String endPoint = 'http://cloud.gutemorgan.com:4005/v1';

  static const String usersCollection = 'users';
  static const String tweetsCollection = 'tweets';
  static const String notificationsCollection = 'notifications';
  static const String messagesCollection = '6456709472b1325badb2';
  static const String chatRoomsCollection = 'chatRooms';

  static const bool appwriteSelfSigned = true;

  static const String imagesBucket = 'images';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
