import 'package:flutter/material.dart';

showAlertDialog(BuildContext context, String msg, String titulo, String botonOK,
    String botonCancel) {
  Widget btnCancelar = 
      ElevatedButton(onPressed: () {}, child: Text(botonCancel));
  
  Widget btnOK = ElevatedButton(
    onPressed: () {
      Navigator.of(context).pop();
    },
    child: Text(botonOK),
  ); // ElevatedButton
  
  AlertDialog alert = AlertDialog(
    title: Text(titulo),
    content: Text(msg),
    actions: [
      btnCancelar,
      btnOK,
    ],
  ); // AlertDialog
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}