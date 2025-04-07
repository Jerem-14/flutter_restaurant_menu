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
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  dish.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Afficher une icône en cas d'erreur de chargement d'image
                    return Container(
                      color: Colors.grey.shade300,
                      child: Center(
                        child: Icon(
                          _getIconForCategory(dish.category),
                          size: 50,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  },
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
    imageUrl: 'assets/images/entrees/caesar_salad.jpg',
    category: 'Entrées',
  ),
  Dish(
    name: 'Soupe à l\'oignon',
    description: 'Soupe à l\'oignon gratinée au fromage, servie avec croûtons',
    price: 7.50,
    imageUrl: 'assets/images/entrees/onion_soup.jpg',
    category: 'Entrées',
  ),
  Dish(
    name: 'Carpaccio de boeuf',
    description: 'Fines tranches de boeuf cru, copeaux de parmesan, câpres et huile d\'olive',
    price: 12.00,
    imageUrl: 'assets/images/beef_carpaccio.jpg',
    category: 'Entrées',
  ),
  Dish(
    name: 'Bruschetta tomates basilic',
    description: 'Pain grillé à l\'ail avec tomates fraîches, basilic et huile d\'olive extra vierge',
    price: 6.50,
    imageUrl: 'assets/images/bruschetta.jpg', // Utilisation de la même image
    category: 'Entrées',
  ),
  Dish(
    name: 'Foie gras maison',
    description: 'Foie gras mi-cuit, chutney de figues et pain brioché toasté',
    price: 14.50,
    imageUrl: 'assets/images/foie-gras-maison.jpg', // Utilisation de la même image
    category: 'Entrées',
  ),
  Dish(
    name: 'Burrata crémeuse',
    description: 'Burrata, tomates cerises, pesto maison et pignons torréfiés',
    price: 9.80,
    imageUrl: 'assets/images/burrata.jpg', // Utilisation de la même image
    category: 'Entrées',
  ),
  Dish(
    name: 'Tartare de saumon',
    description: 'Saumon frais, avocat, mangue et vinaigrette citronnée',
    price: 11.00,
    imageUrl: 'assets/images/tartare-de-saumon.jpg', // Utilisation de la même image
    category: 'Entrées',
  ),
  Dish(
    name: 'Velouté de potimarron',
    description: 'Crème de potimarron à la muscade avec chips de pancetta et crème fraîche',
    price: 7.00,
    imageUrl: 'assets/images/veloute-potimarron.jpg', // Utilisation de la même image
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
  Dish(
    name: 'Magret de canard',
    description: 'Magret de canard rôti, sauce aux fruits rouges et pommes de terre sarladaises',
    price: 22.50,
    imageUrl: 'assets/images/steak_frites.jpg', // Utilisation de la même image
    category: 'Plats',
  ),
  Dish(
    name: 'Tajine d\'agneau',
    description: 'Épaule d\'agneau mijotée, légumes confits, abricots et amandes, semoule aux épices',
    price: 20.00,
    imageUrl: 'assets/images/mushroom_risotto.jpg', // Utilisation de la même image
    category: 'Plats',
  ),
  Dish(
    name: 'Linguine aux fruits de mer',
    description: 'Pâtes fraîches, crevettes, moules, calamars et sauce tomate légèrement relevée',
    price: 17.50,
    imageUrl: 'assets/images/salmon.jpg', // Utilisation de la même image
    category: 'Plats',
  ),
  Dish(
    name: 'Suprême de volaille',
    description: 'Poulet fermier rôti, jus corsé, écrasé de pommes de terre à l\'huile d\'olive et herbes fraîches',
    price: 16.50,
    imageUrl: 'assets/images/steak_frites.jpg', // Utilisation de la même image
    category: 'Plats',
  ),
  Dish(
    name: 'Burger gourmet',
    description: 'Pain artisanal, steak haché de boeuf, comté affiné, bacon croustillant, oignons caramélisés et frites maison',
    price: 17.00,
    imageUrl: 'assets/images/mushroom_risotto.jpg', // Utilisation de la même image
    category: 'Plats',
  ),
  Dish(
    name: 'Curry de légumes',
    description: 'Légumes de saison, lait de coco, curry maison et riz basmati (option végétarienne)',
    price: 14.50,
    imageUrl: 'assets/images/salmon.jpg', // Utilisation de la même image
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
  Dish(
    name: 'Tiramisu',
    description: 'Biscuits café, mascarpone et cacao amer',
    price: 7.50,
    imageUrl: 'assets/images/creme_brulee.jpg', // Utilisation de la même image
    category: 'Desserts',
  ),
  Dish(
    name: 'Profiteroles',
    description: 'Choux croustillants, glace vanille et sauce chocolat chaud',
    price: 8.50,
    imageUrl: 'assets/images/chocolate_fondant.jpg', // Utilisation de la même image
    category: 'Desserts',
  ),
  Dish(
    name: 'Mousse aux fruits rouges',
    description: 'Mousse légère aux fruits rouges, coulis et fruits frais',
    price: 7.00,
    imageUrl: 'assets/images/lemon_pie.jpg', // Utilisation de la même image
    category: 'Desserts',
  ),
  Dish(
    name: 'Carpaccio d\'ananas',
    description: 'Fines tranches d\'ananas, sirop au rhum et sorbet citron vert',
    price: 6.50,
    imageUrl: 'assets/images/creme_brulee.jpg', // Utilisation de la même image
    category: 'Desserts',
  ),
  Dish(
    name: 'Café gourmand',
    description: 'Expresso servi avec une sélection de mignardises',
    price: 8.50,
    imageUrl: 'assets/images/chocolate_fondant.jpg', // Utilisation de la même image
    category: 'Desserts',
  ),
  Dish(
    name: 'Pavlova aux fruits exotiques',
    description: 'Meringue craquante, crème fouettée et fruits exotiques',
    price: 7.80,
    imageUrl: 'assets/images/lemon_pie.jpg', // Utilisation de la même image
    category: 'Desserts',
  ),
];