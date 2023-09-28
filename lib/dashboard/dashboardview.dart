import 'package:_zapp/data_models/crud_model.dart';
import 'package:_zapp/servce/graphql_service.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<DashboardPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<DashboardPage> {
  List<CommentModel>? _comments;
  final GraphQLService _graphQLService = GraphQLService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  bool _isEditMode = false;

  CommentModel? _selectedComment;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    _comments = null;
    _comments = await _graphQLService.getComments(id: 3);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade200,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: _comments == null
              ? const Center(
                  child: CircularProgressIndicator(
                  color: Colors.yellow,
                ))
              : Column(
                  children: [
                    Expanded(
                      child: _comments!.isEmpty
                          ? const Center(child: Text('No comments !!'))
                          : Card(
                              color: Colors.grey.shade200,
                              child: ListView.builder(
                                  itemCount: _comments!.length,
                                  itemBuilder: (context, index) => Card(
                                        child: ListTile(
                                            onTap: () {
                                              _selectedComment =
                                                  _comments![index];

                                              _emailController.text =
                                                  _selectedComment!.email;
                                              _bodyController.text =
                                                  _selectedComment!.body;
                                              _nameController.text =
                                                  _selectedComment!.name;
                                            },
                                            leading: const Icon(Icons.comment),
                                            title: Column(
                                              children: [
                                                Text(
                                                  'Body : ${_comments![index].body.substring(0, 34)}',
                                                  style: const TextStyle(
                                                      color: Colors.orange),
                                                ),
                                                const Divider(),
                                                Text(
                                                  'Name : ${_comments![index].name}',
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const Divider()
                                              ],
                                            ),
                                            subtitle: Text(
                                                'Email :  ${_comments![index].email}'),
                                            trailing: Column(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    await _graphQLService
                                                        .deleteComment(
                                                            id: _comments![
                                                                    index]
                                                                .id
                                                                .toString());
                                                    _load();
                                                  },
                                                ),
                                              ],
                                            )),
                                      )),
                            ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () async {
                              _isEditMode = !_isEditMode;
                              setState(() {});
                            },
                            icon: Icon(_isEditMode ? Icons.edit : Icons.add)),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: _bodyController,
                                  decoration:
                                      const InputDecoration(hintText: 'Body'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: _nameController,
                                  decoration:
                                      const InputDecoration(hintText: 'Name'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: TextField(
                                  controller: _emailController,
                                  decoration:
                                      const InputDecoration(hintText: 'Email'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () async {
                              if (_isEditMode) {
                                await _graphQLService.updateComment(
                                    id: _selectedComment!.id.toString(),
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    body: _bodyController.text);
                              } else {
                                await _graphQLService.createComment(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    body: _bodyController.text);

                                _nameController.clear();
                                _emailController.clear();
                                _bodyController.clear();
                              }

                              _load();
                            },
                            icon: Icon(Icons.send))
                      ],
                    )
                  ],
                )),
    );
  }
}
