import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const twentyFiveMinutes = 1500;

  int totalSeconds = twentyFiveMinutes;
  late Timer timer;
  // import dart:async되어야 하고, Timer를 통해 정해진 가격에 한번씩 함수를 실행하게 한다.
  // timer는 onStartPressed버튼을 누르면 생성이 되는거라서 late를 사용하는 것이다.

  bool isRunning = false;
  int totalPomodoros = 0;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros += 1;
        isRunning = false;
        totalSeconds = twentyFiveMinutes;
      });

      timer.cancel();
    } else {
      setState(() {
        totalSeconds = totalSeconds - 1;
      });
    }
  }
  // error : The argument type 'void Function()' can't be assigned to the parameter type 'void Function(Timer)'.
  // onTick에 Timer 파라미터가 들어가지 않으면 이 에러가 발생한다.

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    /*
    periodic(duration, (timer) {}); periodic은 지정된 duration동안 (timer) {}함수를 실행하게 된다.
    onTick은 onTick()으로 넣으면 안된다. ()가 붙으면 바로 실행이 되게 된다. 주의
    onTick을 지정하면 The argument type이라는 오류가 발생하는데, 이는 void Function()이라서 그렇다.
    void Function(Timer) 으로 Timer 파라미터가 반드시 들어가야 해서 그런 것이다. 그래서 onTick(Timer timer) 으로 구성한 것임
    */

    setState(() {
      isRunning = true;
    });
    // 값이 출력되지 않아도 상태 변경이 되면 setState를 통해 알려줘야 한다.
  }

  void onPausePressed() {
    timer.cancel();

    setState(() {
      isRunning = false;
    });
  }

  String format(int seconds) {
    var duration = Duration(seconds: seconds);
    // Duration을 이용하면 0:24:54.000000 이처럼 출력해 준다. 그냥 변수함수 같음

    //print(duration);
    return duration.toString().split('.').first.substring(2, 7);
    // .을 기준으로 split를 나누어 first(0번째 값)을 가져와 substring으로 2에서 7까지 가져온다.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      //예전의 backgroundColor가 deprecated가 되면서 대신에 colorScheme.background를 사용한다.
      body: Column(
        children: [
          // flexible은 사이즈를 직접 입력하는 형태가 아닌 UI비율에 기반해서 유연하게 구성 가능하다.
          Flexible(
            flex: 1, // 비율설정
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Text(format(totalSeconds),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 89,
                    fontWeight: FontWeight.w600,
                  )),
            ),
          ),
          Flexible(
            flex: 2, // 비율설정 2배로 한다는 것임
            child: Center(
              child: IconButton(
                iconSize: 120,
                color: Theme.of(context).cardColor,
                onPressed: isRunning ? onPausePressed : onStartPressed,
                icon: Icon(isRunning
                    ? Icons.pause_circle_filled_outlined
                    : Icons.play_circle_outline),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            // Container->Column->Row->Expaded 했음.
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      //borderRadius: BorderRadius.circular(50),
                      // 아이폰용으로 안드로이든 안 이뻐서 topLeft, topright 상용함
                      //borderRadius: const BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50),

                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Pomodors',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                        Text(
                          '$totalPomodoros',
                          style: TextStyle(
                            fontSize: 58,
                            fontWeight: FontWeight.w600,
                            color:
                                Theme.of(context).textTheme.displayLarge!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
