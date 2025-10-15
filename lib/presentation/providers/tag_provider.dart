import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiorapp/data/models/tag.dart';
import 'package:kiorapp/data/repositories/tag_repository.dart';

final tagRepositoryProvider = Provider((ref) => TagRepository());

final tagProvider = StateNotifierProvider<TagNotifier, List<Tag>>((ref) {
  return TagNotifier(ref.watch(tagRepositoryProvider));
});

class TagNotifier extends StateNotifier<List<Tag>> {
  final TagRepository _tagRepository;

  TagNotifier(this._tagRepository) : super([]) {
    loadTags();
  }

  Future<void> loadTags() async {
    state = await _tagRepository.getTags();
  }

  Future<void> addTag(Tag tag) async {
    await _tagRepository.insertTag(tag);
    loadTags();
  }

  Future<void> updateTag(Tag tag) async {
    await _tagRepository.updateTag(tag);
    loadTags();
  }

  Future<void> deleteTag(int id) async {
    await _tagRepository.deleteTag(id);
    loadTags();
  }
}
