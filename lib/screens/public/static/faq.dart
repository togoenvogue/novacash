import 'package:flutter/material.dart';

import '../../../helpers/common.dart';
import '../../../models/config.dart';
import '../../../config/configuration.dart';
import '../../../styles/styles.dart';
import '../../../widgets/common/custom_faq.dart';

class FaqScreen extends StatelessWidget {
  final AppConfigModel app;
  FaqScreen({this.app});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Questions Fréquentes',
          style: MyStyles().appBarTextStyle,
        ),
        backgroundColor: MyColors().primary,
        iconTheme: IconThemeData(color: Colors.white),
        shadowColor: Colors.transparent,
      ),
      backgroundColor: MyColors().bgColor,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: app != null
                ? Column(
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/images/icon-faq.png',
                          //fit: BoxFit.cover,
                        ),
                        //decoration: BoxDecoration(color: Colors.green),
                        height: 120,
                        //width: double.infinity,
                      ),
                      SizedBox(height: 8),
                      CustomFaq(
                        question: 'Qu\'est-ce que $appName?',
                        response:
                            '$appName est la réponse à tous vos besoins de pari en ligne en Afrique et partout dans le monde (PMU, FOOTBALL, JACKPOT ...)',
                      ),
                      CustomFaq(
                        question: 'Qui peut utiliser $appName?',
                        response:
                            'Toute personne ayant 18 ans et plus peut utiliser l\'application $appName, peu importe son pays de résidence',
                      ),
                      CustomFaq(
                        question:
                            'Comment créer un compte pour utiliser l\'application $appName?',
                        response:
                            'Cliquez sur le bouton d\'inscription sur l\'écran d\'accueil de l\'application pour vous inscrire gratuitement. Notez cependant que vous devez au préalable avoir sous la main le code d\'invitation d\'un utilisateur de l\'application (qui sera automatiquement votre parrain)',
                      ),
                      CustomFaq(
                        question:
                            'Quels sont les services offerts par l\'application $appName?',
                        response:
                            '''1 - En souscrivant à $appName, vous avez accès à tous les programmes et résultats des courses PMU (classés par réunion), calendriers et résultats des matchs de football (Premier League, Liga, Bundesliga, Champions League, Ligue 1 et 2, Serie A) ...
                      
2 - Vous avez aussi systématiquement accès pour parier sur toutes les courses PMU, tous les matchs de foot, et jouer aux jeux de JACKPOT en direct

3 - A la fin de chaque course et match, vous recevrez une notification (inbox et SMS) pour vous informer des résultats

4 - Enfin si vous le souhaitez, vous pouvez vous abonner auprès d\'un pronostiqueur indépendant dans l\'application pour recevoir ses pronostics tous les jours''',
                      ),
                      CustomFaq(
                        question:
                            'Puis-je recevoir aussi des pronostics (combinaisons) dans l\'application?',
                        response:
                            'Oui. Si vous le souhaitez, vous pouvez vous abonner auprès d\'un pronostiqueur indépendant de votre choix dans l\'application $appName et recevoir tous ses pronostics',
                      ),
                      CustomFaq(
                        question:
                            'Puis-je parier directement dans l\'application $appName?',
                        response:
                            'Bien évidemment ; $appName a été conçu pour vous permettre de parier en toute simplicité, au plus tard 5 minutes avant le début des courses PMU et matchs de football',
                      ),
                      CustomFaq(
                        question:
                            'Quels sont les jeux disponibles dans l\'applicaiton $appName?',
                        response:
                            '$appName vous offre actuellement les jeux de courses de chevaux (PMU, environ 10 courses par jour), mais aussi d\'autres jeux comme le FOOTBALL (environ 10 matchs par jour), le JACKPOT et d\'autres jeux pour bientôt',
                      ),
                      CustomFaq(
                        question:
                            'Quels sont les types de jeux PMU qu\'on peut jouer dans l\'application $appName?',
                        response:
                            '''Lorsque vous jouez au pari PMU sur $appName, vous devez choisir ces 3 types :

a) GAGNANT
En pariant en mode < GAGNANT > lors d\'un pari PMU, cela signifie que vous pariez sur un cheval en espérant qu\'il soit le GAGNANT de la course (la première place). Si votre cheval gagne effectivement la course, alors votre gain sera égal au montant de votre Mise x la Cote du cheval (Gain = Mise x Cote)

b) 2 PREMIERS
En pariant en mode < 2 PREMIERS >, cela signifie que vous pariez sur un cheval en espérant qu\'il arrive parmi les 2 PREMIERS à la fin de la course. Si c'est le cas, alors votre gain sera égal au montant de votre Mise x 2 (Gain = Mise x 2)

c) 3 PREMIERS
En pariant en mode < 3 PREMIERS >, cela signifie que vous pariez sur un cheval en espérant qu\'il arrive parmi les 3 PREMIERS à la fin de la course. Si c'est le cas, votre gain sera égal au montant de votre Mise x 1,5 (Gain = Mise x 1,5)

NB: Notez que les modes < 2 PREMIERS > et < 3 PREMIERS > sont disponibles uniquement sur les courses alignant au moins 10 chevaux au départ''',
                      ),
                      CustomFaq(
                        question:
                            'Que choisir? GAGNANT? 2 PREMIERS? ou 3 PREMIERS?',
                        response:
                            'Tout dépend de votre degré de conviction et le niveau de risque que vous êtes prêt à prendre. Notez tout de même que vos gains en pariant en mode < GAGNANT > sont plus élevés, proportionnellement au risque pris.',
                      ),
                      CustomFaq(
                        question:
                            'Puis-je parier sur plusieurs chevaux à la fois lors dans une course?',
                        response:
                            'Absolument, vous pouvez parier sur plusieurs chevaux à la fois lors d\'une course. Notez cependant que chacun des chevaux que vous choisissez sera placé en pari indépendant',
                      ),
                      CustomFaq(
                        question: 'C\'est quoi le PARISÛR?',
                        response:
                            '''Il s\'agit d\'une assurance (une garantie) à laquelle vous souscrivez au moment de placer un pari (PMU et FOOTBALL).
                            
Si vous cochez l\'option PARISÛR lors d\'un pari PMU, votre mise vous sera entièrement retournée s\'il arrivait que le cheval sur lequel vous avez misé est par la suite déclaré NON PARTANT.
                            
Il en est de même, si vous cochez l\'option PARISÛR lors d\'un pari FOOT et que par la suite le match est annulé ou reporté, votre mise vous sera entièrement retournée.

NB: L\'option PARISÛR n\'est pas gratuite, mais nous vous recommandons vivement de l\'activer pour ne pas perdre inutilement vos mises (mieux vaut prévenir que guérir)''',
                      ),
                      CustomFaq(
                        question:
                            'Combien pourrais-je potentiellement gagner aux jeux JACKPOT?',
                        response:
                            '''Pour participer au JACKPOT BASIC, vous devez parier ${NumberHelper().formatNumber(app.jackpot1_base_amount)} FCFA. Vous pouvez gagner un minimum de ${NumberHelper().formatNumber(app.jackpot1_base_amount * 5)} FCFA et un plafond de ${NumberHelper().formatNumber(app.jackpot1_base_amount * 2500)} FCFA (déduits des taxes et commissions)
 
 Pour participer au JACKPOT VIP, vous devez parier ${NumberHelper().formatNumber(app.jackpot2_base_amount)} FCFA. Vous pouvez gagner un minimum de ${NumberHelper().formatNumber(app.jackpot2_base_amount * 15)} FCFA et un plafond de ${NumberHelper().formatNumber(app.jackpot2_base_amount * 5000)} FCFA (déduits des taxes et commissions)                         
                            ''',
                      ),
                      CustomFaq(
                        question:
                            'Y a-t-il des frais à payer pour bénéficier des services de l\'application $appName?',
                        response:
                            '''Oui, vous devez souscrire à un abonnement de ${NumberHelper().formatNumber(app.expiration_cost)} FCFA par trimestre pour bénéficier des différents services offerts par $appName
                            
Des frais de traitement de ${(app.bet_tax * 100).toString().replaceAll('.', ',')}% sont par ailleurs facturés sur vos paris PMU et FOOTBALL dans l\'application''',
                      ),
                      CustomFaq(
                        question:
                            'Puis-je tester l\'application $appName gratuitement?',
                        response:
                            'Oui, lorsque vous créez votre compte $appName, vous bénéficiez d\'un accès gratuit (période d\'essai) de 7 jours à tous les services. Si vous êtes satisfait par $appName, alors vous devez activer un abonnement premium pour continuer à utiliser toutes les fonctionnalités de l\'application',
                      ),
                      CustomFaq(
                        question:
                            'Puis-je effectuer mes retraits directement dans l\'application?',
                        response:
                            'Oui, $appName vous permet d\'effectuer vos retraits en quelques clicks 24h/24, 7j/7',
                      ),
                      CustomFaq(
                        question: 'Quels sont les moyens de paiement?',
                        response:
                            'Vous pouvez effectuer vos dépôts tout comme vos retraits par Orange Money, Moov Money (Mobicash), TMoney, Flooz et par la cryptomonnaie (Bitcoin et Ethereum)',
                      ),
                      CustomFaq(
                        question: 'Quelles sont les heures de retrait?',
                        response:
                            'Vous pouvez lancer vos retraits à n\'importe quelle heure, 24h/24, 7jours/7',
                      ),
                      CustomFaq(
                        question: 'Quelles sont les limites de retrait',
                        response:
                            'Vous êtes autorisé à effectuer un retrait chaque 24 heures, avec un montant compris entre ${NumberHelper().formatNumber(app.minimum_withdraw)} FCFA et ${NumberHelper().formatNumber(app.maximum_withdrawal)} FCFA par retrait',
                      ),
                      CustomFaq(
                        question:
                            'En combien de temps les retraits sont-ils traités?',
                        response:
                            'Le traitement des retraits peut aller de 5 minutes à 24 heures selon l\'affluence et les conditions techniques',
                      ),
                    ],
                  )
                : Text('...loading'),
          ),
        ),
      ),
    );
  }
}
