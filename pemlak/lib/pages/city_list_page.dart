
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pemlak/services/phone_info.dart';
import 'package:pemlak/services/send_info.dart';

class CityListPage extends StatefulWidget {
  const CityListPage({super.key, required this.name, required this.onDelete});

  final String name;
  final Function(String) onDelete;

  @override
  _CityListPageState createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage>
    with SingleTickerProviderStateMixin {
  bool isDeleted = false;
  late AnimationController _controller;

  SendInfo _sendInfo = SendInfo();
  PhoneInfo _phoneInfo = PhoneInfo();
  late String unique_key;

  Future<String?> keyOkuKesin() async {
  unique_key = await _phoneInfo.keyOkuma();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    keyOkuKesin();
  }

  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> deleteCity(String name) async {
    print("del : ${unique_key}");
    await _sendInfo.fetchDelCity(name, unique_key);
    setState(() {
      isDeleted = true;
    });
    _controller.forward();
    widget.onDelete(name);
  }

  @override
  Widget build(BuildContext context) {
    return isDeleted
        ? SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: _controller,
              curve: Curves.easeOut,
            ),
            child: const SizedBox.shrink(),
          )
        : Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 0),
            child: Slidable(
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => deleteCity(widget.name),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                    borderRadius: BorderRadius.circular(15),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_city,
                      color: Colors.white.withOpacity(0.8),
                      size: 30,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
