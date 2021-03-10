import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cube_transition/cube_transition.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:confetti/confetti.dart';

import '../../../../models/jackpot.dart';
import '../../../../widgets/common/empty_folder.dart';
import '../../../../models/config.dart';
import '../../../../services/config.dart';
import '../../../../screens/account/matrix_core/jackpot/paris.dart';
import '../../../../services/jackpot.dart';
import '../../../../models/user.dart';
import '../../../auth/login.dart';
import '../../../../services/user.dart';
import '../../../../screens/account/matrix_core/expiration/renew.dart';
import '../../../../components/keyboard/keyboard.dart';
import '../../../../widgets/common/custom_alert.dart';
import '../../../../widgets/common/custom_card.dart';
import '../../../../widgets/common/custom_flat_button_rounded.dart';
import '../../../../widgets/common/custom_horizontal_diver.dart';
import '../../../../widgets/common/custom_list_space_between.dart';
import '../../../../styles/styles.dart';
import '../../../../helpers/common.dart';

class JackpotPlayScreen extends StatefulWidget {
  @override
  _JackpotPlayScreenState createState() => _JackpotPlayScreenState();
}

class _JackpotPlayScreenState extends State<JackpotPlayScreen> {
  ConfettiController _confetti;
  AppConfigModel app;
  int _selectedNumber;
  int _systemChoice;
  List<String> _charsList = [];
  List<String> _charsListCopy = [];
  UserModel thisUser;
  final int _countDuration = 5;
  bool _showElements = false;
  final bool _maskChar = false;
  bool isLoading = false;
  dynamic _cagnotte = 0;
  JackpotModel jackpot;
  //dynamic _jackpotCost;
  int _jackpotLimit;
  final player = AudioCache();

  void _getConfigs() async {
    var result = await AppService().app();
    if (result != null && result.error == null) {
      setState(() {
        app = result;
        //_jackpotCost = result.free_coin_amount;
        _jackpotLimit = result.free_coin_limit;
        _cagnotte = result.free_coin_amount;
      });
    }
  }

  /*void _getJackpot() async {
    var result = await JackpotService().jackpot();
    if (result.error == null) {
      setState(() {
        _cagnotte = result.cagnotte1;
      });
    }
  }*/

  void _playSound({String type}) {
    if (type == 'Win') {
      player.play('sounds/win.mp3');
    } else if (type == 'Countdown') {
      player.play('sounds/countdown.wav');
    } else if (type == 'Fail') {
      player.play('sounds/fail.wav');
    } else if (type == 'Sad') {
      player.play('sounds/sad.mp3');
    }
  }

  void _getSelectedNumber({int keyStroke}) {
    if (_charsListCopy.length < 1) {
      setState(() {
        _showElements = true;
        _systemChoice = null;
        _charsList.add(keyStroke.toString());
        _selectedNumber = int.parse(_charsList.join());
        _playSound(type: 'Countdown');
        //print('PIN: $_selectedNumber');
        if (_maskChar == true) {
          _charsListCopy.add('#');
        } else {
          _charsListCopy.add(keyStroke.toString());
        }
      });
    } else {
      setState(() {
        _charsList = [];
        _charsListCopy = [];
        _showElements = false;
        _systemChoice = null;
      });
    }
  }

  // redirect method
  void _redirect() {
    Navigator.of(context).pushReplacement(
      CubePageRoute(
        enterPage: ExpirRenewScreen(),
        exitPage: ExpirRenewScreen(),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _submit() async {
    if (thisUser.nextQuizPlay <= DateTime.now().millisecondsSinceEpoch) {
      if (thisUser.expiry - DateTime.now().millisecondsSinceEpoch <= 0) {
        _playSound(type: 'Sad');
        CustomAlert(
          colorBg: Colors.white,
          colorText: Colors.black,
        ).confirm(
          cancelFn: () {},
          cancelText: 'Non',
          confirmFn: _redirect,
          content: Text(
            'Vous devez disposer d\'un abonnement actif pour participer au Free Coins. Souhaitez-vous activer votre abonnement maintenant?',
            textAlign: TextAlign.center,
          ),
          context: context,
          submitText: 'Oui',
          title: 'Accès refusé',
        );
      } else {
        if (_selectedNumber != null &&
            _selectedNumber > 0 &&
            _selectedNumber <= _jackpotLimit) {
          setState(() {
            isLoading = true;
          });
          CustomAlert().loading(
            context: context,
            dismiss: false,
            isLoading: isLoading,
          );
          var result = await JackpotService().play(
            userChoice: _selectedNumber,
            userKey: thisUser.key,
          );
          //print('result.error: ${result.error}');

          setState(() {
            isLoading = false;
            _systemChoice = null;
          });
          Navigator.of(context).pop();

          if (result.error == null) {
            setState(() {
              _systemChoice = result.systemChoice;
            });
            _resetPlay();
            _getUser();
            if (result.hasWon) {
              _confetti.play();
              _playSound(type: 'Win');
              // pause for 3 seconds
              //await Future.delayed(const Duration(seconds: 3));
              CustomAlert(
                colorBg: Colors.white,
                colorText: Colors.green,
                titleStyle: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.normal,
                ),
              ).alert(
                context,
                'Félicitations!',
                '''Vous venez de gagner un Free Coin de ${NumberHelper().formatNumber(result.amountGained)} FCFA! 
                
Date: ${DateHelper().formatTimeStampFull(DateTime.parse(new DateTime.now().toString()).millisecondsSinceEpoch)}''',
                true,
              );
            } else {
              _resetPlay();
              CustomAlert(
                colorBg: Colors.white,
                colorText: Colors.redAccent,
                titleStyle: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.normal,
                ),
              ).alert(
                context,
                'Désolé!',
                '''Le chiffre caché était < ${result.systemChoice.toString()} >
Votre choix était < ${result.userChoice.toString()} >''',
                true,
              );
              _playSound(type: 'Fail');
            }
          } else {
            _resetPlay();
            CustomAlert(
              colorBg: Colors.white,
              colorText: Colors.black,
            ).alert(
              context,
              'Oops!',
              result.error,
              true,
            );
          }
        } else {
          _resetPlay();
          // erreur
          CustomAlert(
            colorBg: Colors.white,
            colorText: Colors.black,
          ).alert(
            context,
            'Oops!',
            'Une erreur s\'est produite. Veuillez essayer de nouveau',
            true,
          );
        }
      }
    } else {
      _resetPlay();
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops...',
        '''Votre prochaine participation est fixée au: ${DateHelper().formatTimeStampFull(thisUser.nextQuizPlay)}
        
Augmentez votre fréquence de participation en parrainant plus de personnes!''',
        true,
      );
    }
  }

  void _resetPlay() {
    setState(() {
      //_systemChoice = null;
      _selectedNumber = null;
      _charsList = [];
      _charsListCopy = [];
      _showElements = false;
    });
  }

  void _getUser() async {
    setState(() {
      isLoading = true;
    });
    var uzr = await AuthService().getThisUser();
    setState(() {
      isLoading = false;
    });
    if (uzr.error == null) {
      setState(() {
        thisUser = uzr;
      });
    } else if (uzr.error == 'AUTH_EXPIRED') {
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Accès refusé',
        'Vous essayez d\'accéder à un espace sécurisé. Connectez-vous et essayez de nouveau',
        false,
      );
      await Future.delayed(const Duration(seconds: 5));
      Navigator.of(context).pop();
      // redirect to login
      Navigator.of(context).pushReplacement(
        CubePageRoute(
          enterPage: LoginScreen(),
          exitPage: LoginScreen(),
          duration: const Duration(milliseconds: 300),
        ),
      );
    } else {
      // show error
      Navigator.of(context).pop();
      CustomAlert(
        colorBg: Colors.white,
        colorText: Colors.black,
      ).alert(
        context,
        'Oops!',
        uzr.error,
        true,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getConfigs();
    //_getJackpot();
    _getUser();
    _confetti = ConfettiController(duration: const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Free Coins',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().bgColor,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.query_builder,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                CubePageRoute(
                  enterPage: MesParisJackpotBasicScreen(),
                  exitPage: MesParisJackpotBasicScreen(),
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
            tooltip: 'Mes paris',
          ),
        ],
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: app != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                child: thisUser != null && thisUser.key != null
                    ? Column(
                        children: [
                          Container(
                            child: Image.asset(
                              'assets/images/banner_jackpot.jpg',
                              fit: BoxFit.cover,
                            ),
                            //decoration: BoxDecoration(color: Colors.green),
                            height: 80,
                            width: double.infinity,
                          ),
                          SizedBox(height: 5),
                          ConfettiWidget(
                            confettiController: _confetti,
                            blastDirection: pi / 2,
                            emissionFrequency: 0.1,
                            numberOfParticles: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Text(
                                  'Tentez votre chance et gagnez gratuitement entre 1 000 F et 12 000 F tous les jours!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: MyColors().primary,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: MyFontFamily().family1,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                CustomCard(
                                  content: Column(
                                    children: [
                                      CustomListSpaceBetwen(
                                        label: 'Frais',
                                        value: 'Gratuit',
                                      ),
                                      CustomHorizontalDiver(),
                                      CustomListSpaceBetwen(
                                        label: 'A gagner',
                                        value:
                                            '${NumberHelper().formatNumber(_cagnotte)} FCFA',
                                      ),
                                      CustomHorizontalDiver(),
                                      CustomListSpaceBetwen(
                                        label: 'Choix du système',
                                        value: _systemChoice == null
                                            ? '*'
                                            : _systemChoice.toString(),
                                      ),
                                      CustomHorizontalDiver(),
                                      CustomListSpaceBetwen(
                                        label: 'Votre choix',
                                        value: _charsListCopy.length > 0
                                            ? _charsListCopy[0].toString()
                                            : '*',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                if (_charsListCopy.length > 0 && _showElements)
                                  CircularCountDownTimer(
                                    // Countdown duration in Seconds
                                    duration: _countDuration,
                                    // Controller to control (i.e Pause, Resume, Restart) the Countdown
                                    controller: null,
                                    // Width of the Countdown Widget
                                    width: 80,
                                    // Height of the Countdown Widget
                                    height: 80,
                                    // Default Color for Countdown Timer
                                    color: Colors.white,
                                    // Filling Color for Countdown Timer
                                    fillColor: Colors.red,
                                    // Background Color for Countdown Widget
                                    backgroundColor: null,
                                    // Border Thickness of the Countdown Circle
                                    strokeWidth: 5.0,
                                    // Begin and end contours with a flat edge and no extension
                                    strokeCap: StrokeCap.butt,
                                    // Text Style for Countdown Text
                                    textStyle: TextStyle(
                                      fontSize: 30.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    // true for reverse countdown (max to 0), false for forward countdown (0 to max)
                                    isReverse: true,
                                    // true for reverse animation, false for forward animation
                                    isReverseAnimation: true,
                                    // Optional [bool] to hide the [Text] in this widget.
                                    isTimerTextShown: true,

                                    // Function which will execute when the Countdown Ends
                                    onComplete: () {
                                      // Here, do whatever you want
                                      setState(() {
                                        _showElements = false;
                                      });
                                      _submit();
                                    },
                                  ),
                                if (_charsListCopy.length > 0 && _showElements)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: CustomFlatButtonRounded(
                                      label:
                                          'Annuler mon choix : $_selectedNumber',
                                      borderRadius: 50,
                                      function: () {
                                        _resetPlay();
                                      },
                                      bgColor: MyColors().danger,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                SizedBox(height: 7),
                                if (_charsListCopy.length == 0 &&
                                    !_showElements)
                                  _jackpotLimit != null
                                      ? VirtualKeyBoard(
                                          title:
                                              'Quel est le chiffre secret que cache le système selon vous?',
                                          excludeZero: true,
                                          keyCount: _jackpotLimit,
                                          keyFnc: _getSelectedNumber,
                                          color: MyColors().bgColor,
                                        )
                                      : Text('...'),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      )
                    : EmptyFolder(
                        isLoading: isLoading,
                        message: 'Accès restreint',
                      ),
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
