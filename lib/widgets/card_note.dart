
import 'package:flutter/material.dart';
import 'package:notes_app/models/note_model.dart';
import 'package:notes_app/utils/card_color.dart';
import 'package:notes_app/utils/ext_time.dart';

class CardNote extends StatelessWidget {
  const CardNote({super.key, required this.note, required this.index});
  final NoteModel note;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = cardColor[index % cardColor.length];
    return Container(
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.folder_rounded,
                color: Colors.white,
                size: 23,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            note.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: Text(
              note.description,
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.access_time,
                color: Colors.black,
                size: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                DateTime.now().formatTime(note.time),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
