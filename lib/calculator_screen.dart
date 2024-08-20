// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:calculatorz/button_values.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = "";
  String operand = "";
  String number2 = "";


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Soma's  Calculator"),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            //buttons
            Wrap(
              children: Btn.buttonValues
                  .map((value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButton(value)))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: Colors.white24)),
        child: InkWell(
            onTap: () => onBtnTap(value),
            child: Center(
                child: Text(
                    value,
                    style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                    ),
                )
            )
        ),
      ),
    );
  }

  //Button Tap Function
  void onBtnTap(String value){
    //To Check if "Delete" key is pressed and do the function
    if(value == Btn.del){
      delete();
      return;
    }

    //To Check if "Clear" key is pressed and do the function
    if(value == Btn.clr){
      clearAll();
      return;
    }

    //To Check if "Percentage" key is pressed and do the function
    if(value == Btn.per){
      convertToPercentage();
      return;
    }

    //To Check if "Calculate(=)" key is pressed and do the function
    if(value == Btn.calculate){
      calculate();
      return;
    }

    appendValue(value);
  }

  //Calculate Function
  void calculate(){
      if(number1.isEmpty) return;
      if(operand.isEmpty) return;
      if(number2.isEmpty) return;

      final double num1 = double.parse(number1);
      final double num2 = double.parse(number2);

      var result = 0.0;
      switch(operand){
        case Btn.add: result = num1 + num2;
          break;
        case Btn.subtract: result = num1 - num2;
          break;
        case Btn.multiply: result = num1 * num2;
          break;
        case Btn.divide: result = num1 / num2;
          break;
        default:
      }
      setState(() {
        number1 = "$result";

        if (number1.endsWith(".0")){
          number1 = number1.substring(0,number1.length - 2);
        }

        operand = "";
        number2 = "";
      });
  }

  //Percentage Function
  void convertToPercentage(){
    if(number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty){
      //calculate before conversion
      calculate();
    }

    if(operand.isNotEmpty){
      //invalid number e.g 17+
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 ="${(number/100)}";
      operand = "";
      number2 = "";
    });
  }

  //Clear Function(Clr)
  void clearAll(){
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  //Delete Function(D)
  void delete(){
      if(number2.isNotEmpty){
        number2 = number2.substring(0,number2.length - 1);
      }else if(operand.isNotEmpty){
        operand = "";
      }else if(number1.isNotEmpty){
        number1 = number1.substring(0,number1.length - 1);
      }

      setState(() {});
  }

  //For Appending Values
  void appendValue(String value){
    // for non-integer button
    if(value!=Btn.dot && int.tryParse(value) == null){
      if(operand.isNotEmpty && number2.isNotEmpty){
        //Calculate The Equation
        calculate();
      }
      operand = value;
    }else if(number1.isEmpty || operand.isEmpty){
      if(value == Btn.dot && number1.contains(Btn.dot)) return;
      if(number1.isEmpty && value == "0") return;
      if(value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)){
        value = "0.";
      }
      number1 += value;
    }else if(number2.isEmpty || operand.isNotEmpty){
      if(value == Btn.dot && number2.contains(Btn.dot)) return;
      if(value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)){
        value = "0.";
      }
      number2 += value;
    }
    setState(() {});
  }

  // Colour Function
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
