import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/pages/detail_note_page.dart';
import 'package:notes_app/utils/notes_database.dart';
import 'package:notes_app/widgets/card_note.dart';
import 'package:notes_app/widgets/empty_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  late TextEditingController titleController;
  late TextEditingController descriptionControler;
  List<NoteModel> notes = [];

  @override
  void initState() {
    super.initState();
    log('init home');
    refreshNotes();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionControler.dispose();
    NotesDatabase.instance.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        centerTitle: true,
      ),
      body: (isLoading)
          ? Center(
              child: AspectRatio(
                aspectRatio: 2.5,
                child: Lottie.asset('assets/loading.json'),
              ),
            )
          : (notes.isEmpty)
              ? const EmptyWidget()
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: MasonryGridView.builder(
                      itemCount: notes.length,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  DetailNotePage(noteModel: notes[index]),
                            ));
                            setState(() {
                              refreshNotes();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CardNote(note: notes[index], index: index),
                          ),
                        );
                      },
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog();
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.note_add_rounded),
      ),
    );
  }

  Future<dynamic> formAddNote(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Note'.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: 3,
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          content: SizedBox(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: titleController,
                    minLines: null,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      label: const Text('Title'),
                      contentPadding: const EdgeInsets.only(
                        left: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: descriptionControler,
                    textAlignVertical: TextAlignVertical.top,
                    minLines: null,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        label: const Text('Description'),
                        contentPadding: const EdgeInsets.all(20)),
                  ),
                )
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fixedSize: Size(
                  MediaQuery.of(context).size.width / 1.3 / 2.1,
                  40,
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.red,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                addNote();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 17, 124, 22),
                fixedSize: Size(
                  MediaQuery.of(context).size.width / 1.3 / 2.1,
                  40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    ).then((_) {
      _clear();
    });
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        notes = await NotesDatabase.instance.readAllNotes();
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  void _clear() {
    titleController.clear();
    descriptionControler.clear();
  }

  void _showDialog() {
    setState(() {
      titleController = TextEditingController();
      descriptionControler = TextEditingController();
    });
    formAddNote(context);
  }

  Future addNote() async {
    final note = NoteModel(
      title: titleController.text,
      description: descriptionControler.text,
      time: DateTime.now(),
    );
    await NotesDatabase.instance.create(note);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
    refreshNotes();
  }
}
