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
    final textTheme = Theme.of(context).textTheme;

    void showTagDialog({Tag? tag}) {
      final isEditing = tag != null;
      tagNameController.text = isEditing ? tag.name : '';

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: Theme.of(context).cardTheme.shape,
          title: Text(
            isEditing ? 'Edit Tag' : 'New Tag',
            style: textTheme.titleLarge,
          ),
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
      appBar: AppBar(title: Text('Categories', style: textTheme.headlineSmall)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: tags.map((tag) {
              return GestureDetector(
                onTap: () => showTagDialog(tag: tag),
                child: Chip(
                  label: Text(tag.name, style: textTheme.bodyLarge),
                  onDeleted: () {
                    ref.read(tagProvider.notifier).deleteTag(tag.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Category "${tag.name}" deleted')),
                    );
                  },
                  deleteIcon: const Icon(Icons.close, size: 18),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  backgroundColor: Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTagDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
