import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiorapp/data/models/tag.dart';
import 'package:kiorapp/presentation/providers/tag_provider.dart';

class TagsScreen extends ConsumerWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tags = ref.watch(tagProvider);
    final tagNameController = TextEditingController();

    void showTagDialog({Tag? tag}) {
      final isEditing = tag != null;
      tagNameController.text = isEditing ? tag.name : '';

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(isEditing ? 'Edit Tag' : 'New Tag'),
          content: TextField(
            controller: tagNameController,
            decoration: const InputDecoration(labelText: 'Tag Name'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final tagName = tagNameController.text;
                if (tagName.isNotEmpty) {
                  if (isEditing) {
                    final updatedTag = Tag(id: tag.id, name: tagName);
                    ref.read(tagProvider.notifier).updateTag(updatedTag);
                  } else {
                    final newTag = Tag(name: tagName);
                    ref.read(tagProvider.notifier).addTag(newTag);
                  }
                  tagNameController.clear();
                  Navigator.of(context).pop();
                }
              },
              child: Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      body: ListView.builder(
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];
          return Dismissible(
            key: ValueKey(tag.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              ref.read(tagProvider.notifier).deleteTag(tag.id!);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${tag.name} deleted')));
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(tag.name),
              onTap: () => showTagDialog(tag: tag),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTagDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
