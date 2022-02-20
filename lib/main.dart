//python -m http.server 8000
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CalcState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        //Calculator Screen
        home: Scaffold(

          appBar: AppBar(
            title: const Text('Calculator',),
            leading: const Icon(Icons.calculate,),
            actions: [
              AboutScreenButton(),
            ],
          ),

          body: Column(
            children: [

              //This Container separates the numbers from the calculator buttons by adding padding
              Container(
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                color: Colors.cyan,

                //The Consumer Widget is rebuilt whenever notifyListeners is called in the CalcState class
                //to reflect the changes made to the state in the UI
                child: Consumer<CalcState>(

                  //The builder function builds a Widget based on the CalcState
                  builder: (context, state, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${state.firstnumber}',),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(state.op,),
                          Text(state._secondnumber,),
                        ],
                      ),
                    ],
                  ),

                ),
              ),

              ButtonGrid(),

            ],
          ),

        ),
      ),
    )
  );
}

class ButtonGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.count(
        
        //This means 4 elements on the horizontal axis
        crossAxisCount: 4,
        
        children: const [
          CalcButton('7',), CalcButton('8',), CalcButton('9',), CalcButton('+',),
          CalcButton('4',), CalcButton('5',), CalcButton('6',), CalcButton('-',),
          CalcButton('1',), CalcButton('2',), CalcButton('3',), CalcButton('*',),
          CalcButton('.',), CalcButton('0',), CalcButton('prv',), CalcButton('/',),
          CalcButton('clr',), CalcButton('del',), CalcButton('ans',), CalcButton('=',),
        ],
      ),
    );
  }
}

class CalcButton extends StatelessWidget {
  final String str;
  const CalcButton(this.str,);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CalcState>(context, listen: false);
    if (str == '')
      return Container(); //This is a placeholder for empty grid tiles
    else
      return TextButton(
        child: Text(str,),
        onPressed: () {
          if ('+-*/'.contains(str)) state.operation(str);
          else if (str == '=') state.operation('');
          else if (str == 'clr') state.clr();
          else if (str == 'del') state.delete();
          else if (str == 'prv') state.prv();
          else if (str == 'ans') state.ans();
          else state.append(str);
        },
      );
  }
}

class CalcState extends ChangeNotifier {
  double _firstnumber = 0;
  String _secondnumber = '0';
  String _op = '';
  double _answer = 0;

  double get firstnumber => _firstnumber;
  double get secondnumber => double.parse(_secondnumber);
  String get op => _op;

  void operation(String op) {
    switch (_op) {
      case '':
        _firstnumber = secondnumber;
        _secondnumber = '0';
        break;
      case '+':
        _firstnumber += secondnumber;
        _secondnumber = '0';
        break;
      case '-':
        _firstnumber -= secondnumber;
        _secondnumber = '0';
        break;
      case '*':
        _firstnumber *= secondnumber;
        _secondnumber = '0';
        break;
      case '/':
        if (secondnumber != 0)
          _firstnumber /= secondnumber;
        else
          print('INVALID OPERATION');
        _secondnumber = '0';
        break;
      default:
        assert(false);
    }
    if(_op != '') _answer = _firstnumber;
    _op = op;
    notifyListeners();
  }

  void prv() {
    _secondnumber = '$_firstnumber';
    _firstnumber = 0;
    _op = '';
    notifyListeners();
  }

  void ans() {
    _secondnumber = '$_answer';
    notifyListeners();
  }

  void clr() {
    //reset CalcState
    _firstnumber = 0;
    _secondnumber = '0';
    _op = '';
    _answer = 0;
    notifyListeners();
  }

  void append(String digit) {
    if (digit == '.') {
      if (_secondnumber.contains('.') == true) return;
      _secondnumber = '$_secondnumber$digit';
    } else {
      assert(digit.length == 1 && '0123456789'.contains(digit));
      if (_secondnumber == '0')
        _secondnumber = digit;
      else
        _secondnumber = '$_secondnumber$digit';
    }
    notifyListeners();
  }

  void delete() {
    var len = _secondnumber.length;
    assert(len > 0);
    if (len == 1) {
      _secondnumber = '0';
    } else {
      _secondnumber = _secondnumber.substring(0, len - 1);
    }
    notifyListeners();
  }
}

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: const BackButton(),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          'Calculator App gemaakt met Flutter voor GDSC.'
          '.............................................'
          '.............................................'
          '.............................................'
          '.............................................'
          '.............................................'
          '.............................................'
          '.............................................'
          '.............................................'
          '.............................................'
          '.............................................'
          '.............................................'
        ),
      ),
    );
  }
}

class AboutScreenButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AboutScreen()),
        );
      },
      icon: const Icon(Icons.info,),
    );
  }
}
