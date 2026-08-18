import 'package:flutter_test/flutter_test.dart';
import 'package:lume/core/storage/in_memory_storage_client.dart';
import 'package:lume/core/storage/storage_json.dart';
import 'package:lume/layers/data/models/profile_data.dart';

void main() {
  test('writeObject and readObject round-trip JSON payloads', () async {
    final storage = InMemoryStorageClient();
    const data = ProfileData(
      id: 'user-1',
      email: 'user@example.com',
      fullName: 'User',
    );

    await storage.writeObject('profile', data, (value) => value.toJson());
    final cached = await storage.readObject('profile', ProfileData.fromJson);

    expect(cached?.id, data.id);
    expect(cached?.email, data.email);
    expect(cached?.fullName, data.fullName);
  });
}
