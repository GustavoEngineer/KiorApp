import 'package:flutter/material.dart';
import 'package:kiorapp/database/database_helper.dart';
import 'package:kiorapp/models/tag.dart';

class TagsScreen extends StatefulWidget {
  const TagsScreen({super.key});

  @override
  State<TagsScreen> createState() => _TagsScreenState();
}

class _TagsScreenState extends State<TagsScreen> {
  List<Tag> _tags = [];
  final _tagNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    final tags = await DatabaseHelper().getTags();
    setState(() {
      _tags = tags;
    });
  }

  void _showTagDialog({Tag? tag}) {
    final isEditing = tag != null;
    _tagNameController.text = isEditing ? tag.name : '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Tag' : 'New Tag'),
        content: TextField(
          controller: _tagNameController,
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
            onPressed: () async {
              final tagName = _tagNameController.text;
              if (tagName.isNotEmpty) {
                if (isEditing) {
                  final updatedTag = Tag(id: tag.id, name: tagName);
                  await DatabaseHelper().updateTag(updatedTag);
                } else {
                  final newTag = Tag(name: tagName);
                  await DatabaseHelper().insertTag(newTag);
                }
                _tagNameController.clear();
                _loadTags();
                if (mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text(isEditing ? 'Update' : 'Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tags')),
      body: ListView.builder(
        itemCount: _tags.length,
        itemBuilder: (context, index) {
          final tag = _tags[index];
          return Dismissible(
            key: ValueKey(tag.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) async {
              await DatabaseHelper().deleteTag(tag.id!);
              setState(() {
                _tags.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                // No es necesario el mounted check aquí
                SnackBar(content: Text('${tag.name} deleted')),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            child: ListTile(
              title: Text(tag.name),
              onTap: () => _showTagDialog(tag: tag),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTagDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
