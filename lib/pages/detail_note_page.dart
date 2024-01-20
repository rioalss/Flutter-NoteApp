import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/utils/notes_database.dart';
import 'package:notes_app/widgets/detail_note_widget.dart';

class DetailNotePage extends StatefulWidget {
  const DetailNotePage({super.key, required this.noteModel});
  final NoteModel noteModel;
  @override
  State<DetailNotePage> createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  late TextEditingController titleControler;
  late TextEditingController descriptionControler;
  bool isLoading = false;
  late NoteModel note;

  @override
  void initState() {
    note = widget.noteModel.copyWith(
      id: widget.noteModel.id,
      title: widget.noteModel.title,
      description: widget.noteModel.description,
      time: widget.noteModel.time,
    );

    titleControler = TextEditingController(
        text: (note.isNull()) ? widget.noteModel.title : note.title);
    descriptionControler = TextEditingController(
        text: note.isNull() ? widget.noteModel.description : note.description);

    super.initState();
  }

  @override
  void dispose() {
    titleControler.dispose();
    descriptionControler.dispose();
    log('dispose page detail');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Note'),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: () async {
                  await showNote(context);
                },
                child: Icon(
                  Icons.edit_rounded,
                  color: Colors.yellow.shade400,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              InkWell(
                onTap: () async {
                  await isDelete(context);
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.red.shade400,
                ),
              ),
              const SizedBox(
                width: 8,
              ),
            ],
          )
        ],
      ),
      body: (isLoading)
          ? Center(
              child: AspectRatio(
                aspectRatio: 2.5,
                child: Lottie.asset('assets/loading.json'),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DetailNoteWidget(
                      label:
                          (note.isNull()) ? widget.noteModel.title : note.title,
                      isTitle: true),
                  const SizedBox(
                    height: 16,
                  ),
                  DetailNoteWidget(
                      label: (note.isNull())
                          ? widget.noteModel.description
                          : note.description,
                      isTitle: false),
                ],
              ),
            ),
    );
  }

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        await NotesDatabase.instance.readNote(widget.noteModel.id!);
        setState(() {
          isLoading = false;
        });
      },
    );
  }

  Future updateNote() async {
    note = widget.noteModel.copyWith(
      id: widget.noteModel.id,
      title: titleControler.text,
      description: descriptionControler.text,
      time: DateTime.now(),
    );
    await NotesDatabase.instance.update(note);
    if (context.mounted) {
      Navigator.of(context).pop(true);
      refreshNote();
    }
  }

  Future deleteNote() async {
    final delete = await NotesDatabase.instance.delete(widget.noteModel.id!);
    if (context.mounted && delete == 1) {
      alertSuccess(context);
    }
  }

  Future alertSuccess(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        });
        return const AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.green,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Done",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Horayy delete successfully!',
                style: TextStyle(
                  fontSize: 15,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> isDelete(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Delete Note',
            textAlign: TextAlign.center,
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure delete this note?'),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceAround,
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
                  MediaQuery.of(context).size.width / 3,
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
                deleteNote();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                fixedSize: Size(
                  MediaQuery.of(context).size.width / 3,
                  40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> showNote(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit Note'.toUpperCase(),
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
                    controller: titleControler,
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
                updateNote();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent.shade400,
                fixedSize: Size(
                  MediaQuery.of(context).size.width / 1.3 / 2.1,
                  40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Edit',
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
    );
  }
}
