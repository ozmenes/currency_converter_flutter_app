import 'package:currency_converter_flutter_app/services/api_client.dart';
import 'package:currency_converter_flutter_app/widget/drop_down.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({required this.title,Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Instance of the Api client
  final ApiClient _client = ApiClient();
  //call the api
  Future<List<String>?> getCurrencyList()async{
    return await _client.getCurrencies();
  }
  //Setting Main Colors
  Color mainColor = const Color(0xFF212936);
  Color secondColor =  const Color(0xFF2849E5);
  final TextEditingController _inputTextEditingController =TextEditingController();
  //Setting the Variables
  List<String> currencies = [];

  late String _from='';
  late String _to='';

  //variables for exchange rate
  late String _rate;
  String _result = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    (()async{
      List<String>? list = await _client.getCurrencies();
      setState(() {
        currencies= list!;
      });
    })();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 200.0,

                child: const Text("Currency Converter",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextField(
                        onSubmitted: (value) async {
                          _rate = (await _client.getRate(_from, _to)).toStringAsFixed(3);
                          setState(() {
                            _result = (_rate * int.parse(value));
                          });
                        },
                        controller: _inputTextEditingController,
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            labelText: "Input value to convert",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18.0,
                                color: secondColor
                            )
                        ),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 50.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //custom widget
                          customDropDown(currencies, _from, (value){
                            setState(() {
                              _from = value;
                            });
                          }),
                          FloatingActionButton(
                            onPressed: (){
                              String temp=_from;
                              setState(() {
                                _from = _to;
                                _to = temp;
                              });
                            },
                            elevation: 0.0,
                            backgroundColor: secondColor,
                            child: const Icon(Icons.swap_horiz),

                          ),
                          customDropDown(currencies, _to, (value){
                            setState(() {
                              _to = value;
                            });
                          }),
                        ],
                      ),
                      const SizedBox(height: 50.0,),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Column(
                          children:  [
                            const Text("Result",style: TextStyle(
                              color: Colors.black,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold
                            ),),
                            Text(_result,style: TextStyle(
                                color: secondColor,
                                fontSize: 36.0,
                                fontWeight: FontWeight.bold
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
