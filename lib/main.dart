import 'package:flutter/material.dart';

void main() {
  runApp(const RestaurantMenuApp());
}

class RestaurantMenuApp extends StatelessWidget {
  const RestaurantMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu du Restaurant',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const RestaurantMenuPage(),
    );
  }
}

class RestaurantMenuPage extends StatefulWidget {
  const RestaurantMenuPage({super.key});

  @override
  State<RestaurantMenuPage> createState() => _RestaurantMenuPageState();
}

class _RestaurantMenuPageState extends State<RestaurantMenuPage> {
  // Liste des catégories disponibles
  final List<String> categories = ['Entrées', 'Plats', 'Desserts'];

  // Controller pour gérer le PageView
  late PageController _pageController;

  // Index de la page sélectionnée (0 = Entrées, 1 = Plats, 2 = Desserts)
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu du Restaurant'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Zone de catégories défilable horizontalement (Row + ListView)
          Container(
            height: 60,
            color: Colors.grey.shade200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Défilement horizontal
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      foregroundColor: isSelected
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = index;
                        // Animer le pageView vers la page correspondante
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      });
                    },
                    child: Text(
                      categories[index],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),

          // PageView pour permettre de défiler entre les catégories
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                // Mettre à jour l'index sélectionné quand on change de page
                setState(() {
                  _selectedIndex = index;
                });
              },
              itemCount: categories.length,
              itemBuilder: (context, pageIndex) {
                // Filtrer les plats pour la catégorie actuelle
                final filteredDishes = allDishes
                    .where((dish) => dish.category == categories[pageIndex])
                    .toList();

                // Afficher la liste des plats avec défilement vertical
                return ListView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: filteredDishes.length,
                  itemBuilder: (context, index) {
                    return DishCard(dish: filteredDishes[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Widget réutilisable pour afficher un plat sous forme de carte
class DishCard extends StatelessWidget {
  final Dish dish;

  const DishCard({super.key, required this.dish});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image du plat (simulée avec un container coloré)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.grey.shade300,
                child: Center(
                  // Normalement ici on utiliserait Image.asset avec le chemin de l'image
                  // Mais pour simplifier l'exemple, on utilise une icône
                  child: Icon(
                    _getIconForCategory(dish.category),
                    size: 50,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),

            // Informations sur le plat
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    dish.description,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${dish.price.toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction utilitaire pour déterminer l'icône à afficher selon la catégorie
  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Entrées':
        return Icons.soup_kitchen;
      case 'Plats':
        return Icons.restaurant;
      case 'Desserts':
        return Icons.cake;
      default:
        return Icons.food_bank;
    }
  }
}

// Classe pour représenter un plat
class Dish {
  final String name;
  final String description;
  final double price;
  final String imageUrl; // Non utilisé dans cet exemple simplifié
  final String category;

  Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

// Données de démonstration (codées en dur)
final List<Dish> allDishes = [
  // Entrées
  Dish(
    name: 'Salade César',
    description: 'Laitue romaine, parmesan, croûtons et sauce César maison',
    price: 8.50,
    imageUrl: 'assets/images/caesar_salad.jpg',
    category: 'Entrées',
  ),
  Dish(
    name: 'Soupe à l\'oignon',
    description: 'Soupe à l\'oignon gratinée au fromage, servie avec croûtons',
    price: 7.50,
    imageUrl: 'assets/images/onion_soup.jpg',
    category: 'Entrées',
  ),
  Dish(
    name: 'Carpaccio de boeuf',
    description: 'Fines tranches de boeuf cru, copeaux de parmesan, câpres et huile d\'olive',
    price: 12.00,
    imageUrl: 'assets/images/beef_carpaccio.jpg',
    category: 'Entrées',
  ),

  // Plats
  Dish(
    name: 'Steak frites',
    description: 'Pièce de boeuf grillée, frites maison et sauce béarnaise',
    price: 18.50,
    imageUrl: 'assets/images/steak_frites.jpg',
    category: 'Plats',
  ),
  Dish(
    name: 'Risotto aux champignons',
    description: 'Risotto crémeux aux champignons sauvages et parmesan',
    price: 16.00,
    imageUrl: 'assets/images/mushroom_risotto.jpg',
    category: 'Plats',
  ),
  Dish(
    name: 'Filet de saumon',
    description: 'Filet de saumon grillé, purée de pommes de terre et légumes de saison',
    price: 19.00,
    imageUrl: 'assets/images/salmon.jpg',
    category: 'Plats',
  ),

  // Desserts
  Dish(
    name: 'Crème brûlée',
    description: 'Crème vanillée caramélisée traditionnelle',
    price: 7.00,
    imageUrl: 'assets/images/creme_brulee.jpg',
    category: 'Desserts',
  ),
  Dish(
    name: 'Tarte au citron meringuée',
    description: 'Tarte au citron avec meringue légère et croustillante',
    price: 6.50,
    imageUrl: 'assets/images/lemon_pie.jpg',
    category: 'Desserts',
  ),
  Dish(
    name: 'Fondant au chocolat',
    description: 'Gâteau au chocolat coulant servi avec glace vanille et coulis de fruits rouges',
    price: 8.00,
    imageUrl: 'assets/images/chocolate_fondant.jpg',
    category: 'Desserts',
  ),
];