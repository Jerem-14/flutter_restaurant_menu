# Restaurant Menu App

Une application Flutter pour afficher le menu d'un restaurant avec une interface intuitive et élégante. Cette application permet aux utilisateurs de naviguer entre différentes catégories de plats (Entrées, Plats, Desserts) et de consulter les détails de chaque plat.

## 📱 Aperçu

*Note: Les captures d'écran seront ajoutées après la première compilation de l'application.*

L'application présente:
- Une barre de navigation horizontale pour choisir entre différentes catégories
- Un système de pagination permettant de faire défiler horizontalement entre les catégories
- Des cartes détaillées pour chaque plat avec image, description et prix
- Une interface responsive et moderne

## ✨ Fonctionnalités

- **Navigation par catégories** : Défilement horizontal entre les différentes sections du menu
- **Affichage des plats** : Cartes visuelles présentant les informations essentielles de chaque plat
- **Interface interactive** : Navigation fluide avec animations de transition
- **Design responsive** : Adaptation à différentes tailles d'écran
- **Structure de code réutilisable** : Organisation modulaire pour faciliter les extensions

## 🔧 Prérequis

- Flutter SDK (version 3.0.0 ou supérieure)
- Dart SDK (version 2.17.0 ou supérieure)
- Un éditeur de code comme Android Studio, VS Code, etc.
- Un appareil Android/iOS ou un émulateur pour tester l'application

## 🚀 Installation

1. Clonez ce dépôt sur votre machine locale :
   ```bash
   git clone https://github.com/votre-username/restaurant_menu_app.git
   ```

2. Accédez au répertoire du projet :
   ```bash
   cd restaurant_menu_app
   ```

3. Récupérez les dépendances :
   ```bash
   flutter pub get
   ```

4. Exécutez l'application :
   ```bash
   flutter run
   ```

## 📁 Structure du projet

```
restaurant_menu_app/
├── lib/
│   ├── main.dart        # Point d'entrée de l'application
│   ├── models/          # Classes modèles (à créer pour une meilleure organisation)
│   ├── screens/         # Écrans de l'application (à créer)
│   └── widgets/         # Widgets réutilisables (à créer)
├── assets/
│   └── images/          # Images pour les plats
├── pubspec.yaml         # Configuration du projet et dépendances
└── README.md            # Documentation du projet
```

## 💻 Organisation du code

L'application est structurée selon les principes de conception Flutter :

- **main.dart** : Configure l'application et définit le thème global
- **RestaurantMenuApp** : Widget racine de l'application
- **RestaurantMenuPage** : Page principale avec la navigation par catégories
- **DishCard** : Widget réutilisable pour l'affichage d'un plat
- **Dish** : Classe modèle pour représenter les données d'un plat

### Composants principaux

#### Navigation par catégories
Utilise une combinaison de `ListView.builder` horizontal pour les onglets et `PageView.builder` pour permettre le défilement entre les catégories.

#### Carte de plat
Un widget `Card` personnalisé avec une mise en page soignée incluant l'image, le nom, la description et le prix du plat.

## 🔍 Détails techniques

- **Gestion de l'état** : Utilisation de `setState` pour la gestion d'état locale
- **Navigation** : Utilisation de `PageController` pour synchroniser les onglets avec le contenu
- **Animations** : Transitions animées lors du changement de catégorie
- **Layouts** : Utilisation appropriée de `Column`, `Row`, `Expanded` et `ListView`

## 🛠️ Améliorations futures

- Ajout d'une fonctionnalité de recherche
- Filtres supplémentaires (végétarien, sans gluten, etc.)
- Détails des plats sur une page dédiée
- Gestion des favoris
- Support multilingue
- Mode sombre/clair
- Stockage des données sur Firebase ou une API REST

## 📝 Notes de développement

Ce projet a été développé dans le cadre d'un TD Flutter sur les layouts et la navigation. Il met l'accent sur l'utilisation appropriée des widgets de mise en page Flutter et la création d'une interface utilisateur intuitive et responsive.

### Points importants du code

- Utilisation de widgets défilables (ListView, PageView)
- Création de composants réutilisables
- Synchronisation entre la sélection d'onglets et le PageView
- Structure de données bien organisée

### Critères d'évaluation ciblés

- Affichage correct des catégories scrollables
- Présentation soignée et homogène des plats
- Utilisation pertinente des layouts Flutter
- Fonctionnement de la logique de sélection
- Organisation et clarté du code

## 📄 Licence

Ce projet est disponible sous licence MIT.

---
