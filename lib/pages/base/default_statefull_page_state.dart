import "package:flutter/material.dart";
import 'package:simulador_investimentos/themes/colors.dart';
import 'package:simulador_investimentos/widgets/person_identification.dart';
import 'package:simulador_investimentos/widgets/tab_option.dart';

import 'default_statefull_page.dart';

class DefaultStatefullPageState extends State<DefaultStatefullPage> {

  bool _showBottomMenu;

  DefaultStatefullPageState(bool showBottomMenu) {
    this._showBottomMenu = showBottomMenu;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: PersonIdentification(),
        elevation: 0,
      ),
      body: body(),
    );
  }

  Widget body() {
    List<Widget> widgets = buildWidgets();
    if (_showBottomMenu) {
      widgets.add(TabOption());
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 20, top: 20),
      child: Column(
        children: widgets,
      ),
    );
  }

  List<Widget> buildWidgets() {
    var widgets = <Widget>[
    ];
    return widgets;
  }

}