// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../constants.dart';

class ExpenseTile extends StatelessWidget {
  ExpenseTile(
      {super.key,
      required this.expenseName,
      required this.expenseAmount,
      required this.dateTime,
      required this.deleteTapped,
      required this.editTapped,
       required this.category});
  final String expenseName;
  final double expenseAmount;
  final String dateTime;
  void Function(BuildContext)? deleteTapped;
  void Function(BuildContext)? editTapped;
   final String category;

  @override
  Widget build(BuildContext context) {
    String categoryIcon='assets/${category.toLowerCase()}.png';
    return Slidable(
      endActionPane: ActionPane(
        motion: const StretchMotion(),
        children: [
          SlidableAction(
            onPressed: deleteTapped,
            icon: Icons.delete,
            backgroundColor: Colors.black87,
            borderRadius: BorderRadius.circular(9),
          ),
          SlidableAction(
            onPressed: editTapped,
            icon: Icons.edit,
            backgroundColor: Colors.black87,
            borderRadius: BorderRadius.circular(9),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 35,
          backgroundColor: Colors.transparent,
          child:Image.asset(categoryIcon,height: 45,),
        ),
        title: Text(
          expenseName,
          style: const TextStyle(fontWeight: FontWeight.w900,fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(dateTime),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.greenAccent
              ),
              child: Text(category,style: const TextStyle(fontWeight: FontWeight.bold),),
            ),
          ],
        ),
        trailing: Text(
          "$kRupeeSymbol ${expenseAmount.toStringAsFixed(1)}",
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87),
        ),
      ),
    );
  }
}
