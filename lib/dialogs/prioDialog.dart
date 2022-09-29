import 'package:flutter/material.dart';

class prioDialog extends StatefulWidget {
  const prioDialog({required this.color, required this.title, required this.subtitle, Key? key}) : super(key: key);

  final Color color;
  final String title;
  final String subtitle;
  @override
  State<prioDialog> createState() => _prioDialogState();
}

class _prioDialogState extends State<prioDialog> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              height: 340,
              padding: const EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: widget.color
                    ),
                  ),

                  Text(
                    widget.subtitle,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 13
                    ),
                  ),
                  TextButton(
                    onPressed: (){Navigator.pop(context);},
                    child: Text("Close"),
                  )
                ],
              ),
            )
        )
    );
  }
}
