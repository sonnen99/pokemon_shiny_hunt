import 'package:flutter/material.dart';

class HuntScreen extends StatefulWidget {
  static const String id = 'hunt_screen';
  final String pokemon;
  const HuntScreen({required this.pokemon});

  @override
  State<HuntScreen> createState() => _HuntScreenState();
}

class _HuntScreenState extends State<HuntScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
