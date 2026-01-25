import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
class TestGframe extends StatefulWidget
{
  @override
  _TestGframeState createState() => _TestGframeState();
}

class _TestGframeState extends State<TestGframe>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Gframe'),
      ),
      body: Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}