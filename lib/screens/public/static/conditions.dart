import 'package:flutter/material.dart';

import '../../../styles/styles.dart';
import '../../../config/configuration.dart';
import '../../../widgets/common/custom_list_vertical.dart';

class ConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conditions générales',
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
            child: Column(
              children: [
                Container(
                  child: Image.asset(
                    'assets/images/icon-contract.png',
                    //fit: BoxFit.cover,
                  ),
                  //decoration: BoxDecoration(color: Colors.green),
                  height: 120,
                  //width: double.infinity,
                ),
                Container(
                  child: Text(
                    '''NovaBets propose à l'utilisateur (ci-après l' "Utilisateur”), d’accéder aux Services Payants de l’application (ci-après "Services Payants").NovaBets se réserve le droit de mettre à jour son application et modifier les présentes Conditions Générales sans avoir à notifier préalablement les utilisateurs.

L’objet des présentes Conditions Générales (ci-après les "Conditions Générales") est de fixer les règles d’utilisations de l’application NovaBets par l’Utilisateur ainsi que les engagements de NovaBets.L'Utilisateur est invité à consulter régulièrement les Conditions Générales pour prendre connaissance des éventuelles modifications.''',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: 10),
                CustomListVertical(
                  label: 'Article 1: L\'objet',
                  value:
                      '''Le présent contrat a pour objet de définir les modalités et les conditions d’utilisations selon lesquelles NovaBets met à la disposition de l'Utilisateur, à partir de son application, des Services Payants de consultation de contenus hippiques et autres sports, ainsi que des paris en ligne.
                
La souscription aux Services Payants emporte l'acceptation des présentes Conditions Générales par l'Utilisateur. L'Utilisateur déclare et reconnaît, en conséquence, avoir lu les présentes Conditions générales.
                      
NovaBets se réserve le droit de modifier tout ou partie et à tout moment les présentes Conditions générales. Nos services payants sont destinés à toute personne âgé au moins de 18 ans.

L'Utilisateur est seul responsable de l'utilisation de son compte client : toute connexion ou transmission de données effectuée en utilisant les Services Payants sera réputée avoir été effectuée par l'Utilisateur lui-même et sous sa responsabilité exclusive. L’Utilisateur s'engage à notifier à NovaBets toute utilisation non autorisée de son compte dès qu'il en a connaissance.

En cas de non-respect par un Utilisateur des présentes Conditions générales, NovaBets se réserve le droit de lui suspendre son accès aux Service.''',
                ),
                CustomListVertical(
                  label: 'Article 2: Alerte aux mineurs',
                  value:
                      '''Vous ne pouvez pas utiliser $appName si vous êtes un mineur. En vous inscrivant, vous déclarez pouvoir éventuellement apporter la preuve que vous êtes âgé(e) de 18 ans ou plus. Si tel n\'est pas le cas, vous devez immédiatement fermer l\'application et passer à autre chose.''',
                ),
                CustomListVertical(
                  label: 'Article 3: Les services payants',
                  value:
                      '''Par l'intermédiaire de l\'application NovaBets, l\'Utilisateur aura accès et pourra librement souscrire un abonnement « Premium » lui permettant de bénéficier des modules « Premium » constitués des « Programmes des courses PMU », les « Résultats des courses PMU », les « Calendriers des matchs de football », les « Paris PMU et Foot », les « Paris Jackpot », ...

L’offre "Premium" est une formule « d’abonnement trimestriel » au prix de 5 000 FCFA valable 90 jours et reconductible tacitement à la date de fin de période. Le paiement de cet abonnement se réalise par prélèvement du solde dépôt du compte de l'utilisateur. A tout moment l'utilisateur est libre de résilier son abonnement dans son espace personnel. L'Utilisateur sera en mesure de consulter l'état de son abonnement sur son compte (profil), après avoir saisi son code Utilisateur (numéro de téléphone) et son mot de passe enregistré lors de son inscription gratuite comme membre.''',
                ),
                CustomListVertical(
                  label: 'Article 4: La période d’essai',
                  value:
                      '''En vous inscrivant sur l'application NovaBets, vous bénéficiez d'une période test de 7 jours. Vous avez un accès sans limite à toutes les fonctionnalités pour tester tous modules de l\'application $appName, entre autres les programmes et arrivées des courses PMU, le calendrier des matchs de Football, etc... Vous pouvez aussi faire des dépôts et parier sur toutes les courses PMU et tous les matchs de football, jouer au Jackpot 7j/7, 24h/24.
                      
Pendant ou après votre période d\'essai de 7 jours, vous devez activer l\'abonnement premium pour continuer à accéder à toutes les fonctionnalités de l\'application.''',
                ),
                CustomListVertical(
                  label: 'Article 5: Les alertes SMS',
                  value:
                      '''En tant que membre actif (disposant d’un abonnement premium valide), vous recevez régulièrement des alertes SMS, entre autres le résultat des courses PMU et Foot, le statut de vos paris (gain ou perte), etc. Les alertes SMS sont totalement gratuites.''',
                ),
                CustomListVertical(
                  label: 'Article 6: Dépôts',
                  value:
                      '''Afin de pouvoir placer des paris, activer ou renouveler son abonnement « Premium » ou encore souscrire aux pronostics, l’Utilisateur devra créditer son « Compte Dépôt » en faisant un dépôt par l’un des moyens fournis dans l’application NovaBets. Il s’agit entre autres du Mobile Money, de Bitcoin et d’Ethereum. Il peut également utiliser une partie de ses gains pour créditer instantanément son « Compte Dépôt », gratuitement.

Le « Compte Dépôt » de l’Utilisateur est crédité seulement lorsque NovaBets constate l’effectivité du paiement effectué par ce dernier. Il est à noter que l’Utilisateur peut créditer son compte à partir de 1 000 (mille francs) Fcfa.

Notez que les éventuels frais liés aux dépôts sont à la charge de l'Utilisateur''',
                ),
                CustomListVertical(
                  label: 'Article 7: Retrait des gains',
                  value:
                      '''Les gains de l’Utilisateur proviennent essentiellement des paris qu’il gagne et des commissions tirées du programme d’affiliation de NovaBets. Ces différents gains sont crédités sur le portefeuille (« Compte Retrait ») de l’Utilisateur en temps réel.

Ce dernier peut donc lancer le retrait de ses gains à travers le Mobile Money, Bitcoin ou encore Ethereum, en disposant d’un abonnement « Premium » valide.

L’Utilisateur doit par ailleurs disposer d’un minimum de 1 000 (mille francs) CFA sur son « Compte Retrait » pour pouvoir initier le retrait, et ce, une seule fois en 24 heures, avec un plafond de 100 000 (cent mille francs) CFA par retrait.

Les retraits peuvent se faire tous les jours, à n’importe quelle heure et sont traités dans un maximum de 24 heures.''',
                ),
                CustomListVertical(
                  label: 'Article 8: Transfert des gains',
                  value:
                      '''A défaut de retirer ses gains ou de les utiliser pour créditer son « Compte Dépôt », l’Utilisateur peut les transférer à un autre utilisateur de l’application. Les transferts sont instantanés et gratuits, peu importe le montant.''',
                ),
                CustomListVertical(
                  label: 'Article 9: Les pronostics',
                  value:
                      '''Les pronostics auxquels l’Utilisateur peut souscrire dans l’application NovaBets sont fournis par des pronostiqueurs indépendants. L’utilisateur dispose d’un accès à la liste des pronostiqueurs et choisit librement celui auprès duquel il voudra s’abonner et recevoir ses pronostics.''',
                ),
                CustomListVertical(
                  label: 'Article 10: Le pari en ligne',
                  value:
                      '''L’Utilisateur qui souhaite placer des paris en ligne (essentiellement le pari PMU et le pari FOOT) devra le faire au moins 5 minutes avant le début de la course ou du match.
                      
Quant aux jeux JACKPOT, ils sont disponibles 24h/24.''',
                ),
                CustomListVertical(
                  label: 'Article 11: L’affiliation',
                  value:
                      '''En dehors des gains tirés des paris, $appName vous donne la possibilité de gagner de l\'argent supplémentaire en recommandant l'application à de nouveaux utilisateurs.

NovaBets vous paie des commissions allant de 5 à 15% (du niveau 1 au niveau 3) lorsque les membres de votre équipe renouvellent leurs abonnements Premium ou gagnent au Jackpot.

✅ Niveau 1: 15%
✅ Niveau 2: 5%
✅ Niveau 3: 5%''',
                ),
                CustomListVertical(
                  label:
                      'Article 12: Prés requis techniques, qualité des services et responsabilités',
                  value:
                      '''Il est précisé que la responsabilité de NovaBets ne pourra en aucun moment être engagée dans le cas d'une configuration ou de ressources non suffisantes de l’appareil de l'Utilisateur. NovaBets emploiera ses meilleurs efforts pour maintenir les Services Payants dans un état opérationnel. Toutefois, NovaBets n'offre aucune garantie quant au fonctionnement ininterrompu du Service.
              
Dans le cas où la responsabilité de NovaBets serait engagée à la suite d'un manquement à l'une de ses obligations au titre des présentes Conditions, la réparation ne s'appliquera qu'aux seuls dommages directs, personnels et certains, à l'exclusion expresse de la réparation de tous dommages et/ou préjudices indirects et immatériels, tels que les préjudices financiers et les pertes de données.

NovaBets se réserve le droit de modifier les présentes conditions générales et de suspendre ou de modifier ses services à tout moment sans préavis, sans que cela donne lieu à compensation de quelque sorte que ce soit.''',
                ),
                CustomListVertical(
                  label: 'Article 13: Propriété',
                  value:
                      '''NovaBets est une marque, propriété de la société NovaLead. Tous droits de propriété intellectuelle ou industrielle de l’application NovaBets et tous les éléments s'y rapportant (textes, images, créations graphiques ...) restent la propriété exclusive de la société NovaLead.''',
                ),
                CustomListVertical(
                  label: 'Article 14: Exonération de responsabilité',
                  value:
                      '''Il est précisé que les informations relatives à la numérotation des chevaux donnant lieux à des pronostics ne sont données qu’à titre indicatif. NovaBets n'assume aucune responsabilité relative à l'utilisation de ces informations et décline également toute responsabilité en cas d'erreur, inexactitude, indisponibilité, interruption, retard ou omission dans l'information.

Seule fait foi la numérotation officielle et les informations du PMU et des autres opérateurs de paris hippiques.

L'utilisation des données et des informations éditées par NovaBets sont sous la responsabilité des internautes. NovaBets ne pourra pas être responsable en cas d'utilisation d'informations ou de données qui ont causé un préjudice résultant d'un dommage matériel ou immatériel et/ou indirect quelqu'il soit.''',
                ),
                CustomListVertical(
                  label:
                      'Article 15: Données personnelles, lois applicables et responsabilités',
                  value:
                      '''NovaBets s'engage à respecter la législation en vigueur en France et notamment les dispositions relatives à la loi n° 78-17 du 6 janvier 1978 dite " Informatique et Libertés " et la loi européenne du 27 avril 2016, le RGPD (Règlement Général sur la Protection des Données). L'Utilisateur bénéficie d'un droit d'accès, de rectification et d'opposition à la cession de ces données qu'il peut exercer en adressant un message à l'adresse électronique suivante : novabets[at]novalead.dev
                  
Les présentes Conditions Générales sont soumises au droit Burkinabé. En cas de contestation sur leurs interprétations ou sur l'exécution de l'une quelconque de leurs stipulations et à défaut d'accord amiable entre les parties, les tribunaux de Ouagadougou seront seuls compétents pour traiter le litige.

L'Utilisateur s'engage à utiliser le service conformément aux lois et règlements en vigueur, et à ne pas porter atteinte aux droits de tiers. L’Utilisateur assume l'entière responsabilité civile, pénale, et administrative du contenu des messages qu'il envoie à des tiers ou qu'il poste sur les forums. L'Utilisateur reconnaît avoir la capacité juridique de procéder à tout engagement contractuel lors de l'utilisation des Services Payants de NovaBets.''',
                ),
                SizedBox(height: 10),
                Text(
                  'Mise à jour: 1er Février 2021',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
