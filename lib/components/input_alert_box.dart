import 'package:flutter/material.dart';

class MyInputBox extends StatelessWidget {
  final TextEditingController textcontroller;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;
  const MyInputBox({super.key,
    required this.hintText,
    required this.onPressed,
    required this.onPressedText,
    required this.textcontroller,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,

      //TextField (user can type here)
      content: TextField(
        controller: textcontroller,

        //let limit the max character
        maxLength: 140,
        maxLines: 3,

        decoration: InputDecoration(
          //border when textfield is unselected
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),

          //border when textfield is selected
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary) ,
                borderRadius: BorderRadius.circular(12)
          ),

          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),

          //Color inside of text field
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,

          //counter style
          counterStyle: TextStyle(color: Theme.of(context).colorScheme.primary)
        ),
      ),
      //Button
      actions: [
        //cancel button
        TextButton(
            onPressed: (){
              //close box
              Navigator.pop(context);

              //clear controller
              textcontroller.clear();
            },
            child: const Text("Cancel"),
        ),
        //yes button
        TextButton(
            onPressed: () {
            //close box
          Navigator.pop(context);

          //execute function
          onPressed!();

          //clear controller
          textcontroller.clear();
          },
            child: Text(onPressedText),
        )
      ],
    );
  }
}
