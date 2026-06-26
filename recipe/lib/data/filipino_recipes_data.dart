import 'dart:math';
import '../models/recipe_model.dart';
import '../models/category_model.dart';

/// Local data source for all 18 hardcoded Filipino cuisine recipes.
/// Uses asset images bundled with the app — no network needed.
class FilipinoRecipesData {
  // ─── Internal recipe list ───────────────────────────────────────────────────

  static final List<Recipe> _all = [
    // 1. Bicol Express
    Recipe(
      id: 'fil_001',
      name: 'Bicol Express',
      category: 'Main Course',
      area: 'Bicol',
      thumbnail: 'assets/bicol express.jpg',
      tags: 'Spicy,Coconut,Pork',
      ingredients: [
        Ingredient(name: 'Pork belly', measure: '500g, cut into 1-inch strips'),
        Ingredient(name: 'Coconut milk (gata)', measure: '2 cups'),
        Ingredient(name: 'Thick coconut cream (kakang gata)', measure: '1 cup'),
        Ingredient(name: 'Green bird\'s eye chilies (siling labuyo)', measure: '8–10 pieces, sliced'),
        Ingredient(name: 'Long green chilies (siling haba)', measure: '4 pieces, sliced'),
        Ingredient(name: 'Garlic', measure: '3 cloves, minced'),
        Ingredient(name: 'Onion', measure: '1 medium, chopped'),
        Ingredient(name: 'Sautéed shrimp paste (bagoong alamang)', measure: '2 tbsp'),
        Ingredient(name: 'Cooking oil', measure: '1 tbsp'),
        Ingredient(name: 'Salt and black pepper', measure: 'to taste'),
      ],
      instructions: '''Step 1 — Prepare Chilies: Wear gloves to slice the green bird's eye chilies and long green chilies. Adjust the amount of siling labuyo to control the spice level.

Step 2 — Sauté Aromatics: Heat 1 tablespoon of cooking oil in a deep pan or wok over medium heat. Sauté the minced garlic and chopped onions for 2 to 3 minutes until soft and fragrant.

Step 3 — Brown the Pork: Toss in the pork belly strips. Cook for 5 to 7 minutes, stirring occasionally, until the pork turns a light golden brown and starts rendering its own fat.

Step 4 — Toast Shrimp Paste: Add the shrimp paste into the pan, mixing it thoroughly with the pork. Fry for 2 to 3 minutes until the paste loses its raw smell and turns fragrant.

Step 5 — Pour Coconut Milk: Pour in the 2 cups of thin coconut milk (gata). Stir gently to dissolve any browned bits stuck to the bottom of the pan.

Step 6 — Simmer Until Tender: Bring the mixture to a gentle boil, then turn the heat down to low. Cover the pan and let it simmer for 20 to 25 minutes until the pork belly becomes completely fork-tender.

Step 7 — Thicken with Cream: Uncover the pan, toss in both types of sliced chilies, and pour in the thick coconut cream (kakang gata). Simmer over medium-low heat, stirring frequently to prevent the milk from curdling or burning.

Step 8 — Render the Oil: Continue simmering until the liquid reduces drastically and begins to separate into a rich, aromatic oil (naglana). Taste, adjust with salt and pepper if needed, and serve screaming hot over steamed white rice.''',
    ),

    // 2. Bulalo
    Recipe(
      id: 'fil_002',
      name: 'Bulalo',
      category: 'Soup',
      area: 'Batangas',
      thumbnail: 'assets/bulalo.jpg',
      tags: 'Beef,Soup,Bone Marrow',
      ingredients: [
        Ingredient(name: 'Beef shank (bone-in marrow)', measure: '1 kg'),
        Ingredient(name: 'Yellow onion', measure: '1 large, halved'),
        Ingredient(name: 'Sweet corn', measure: '2 cobs, cut into thirds'),
        Ingredient(name: 'Potatoes', measure: '2 medium, peeled and quartered'),
        Ingredient(name: 'Cabbage', measure: '1 small head, cut into wedges'),
        Ingredient(name: 'Pechay (bok choy)', measure: '1 bundle, stalks separated'),
        Ingredient(name: 'Water', measure: '10 cups'),
        Ingredient(name: 'Fish sauce (patis)', measure: '3 tbsp'),
        Ingredient(name: 'Whole black peppercorns', measure: '1 tbsp'),
      ],
      instructions: '''Step 1 — Prep the Shanks: Thoroughly rinse the beef shanks under cold water, taking care to wipe away small bone fragments without dislodging the raw marrow inside.

Step 2 — Boil and Clean: Place the shanks into a large, deep stockpot and pour in 10 cups of cold water. Bring to a rapid boil over high heat.

Step 3 — Skim Impurities: Spend the first 5 to 10 minutes aggressively skimming off the gray foam and impurities that rise to the surface to guarantee a crystal-clear broth.

Step 4 — Add Aromatics: Drop the halved yellow onion and 1 tablespoon of whole black peppercorns into the pot once the liquid runs clear.

Step 5 — Slow Braise: Turn the heat down to low, cover the pot tightly, and let it simmer for 2 to 2.5 hours. The beef is ready when it is completely tender and pulling away from the bone.

Step 6 — Cook Root Crops: Drop in the sweet corn pieces and quartered potatoes. Keep the pot uncovered and simmer for 10 to 12 minutes until the potatoes can be easily pierced with a fork.

Step 7 — Season Broth: Pour in the fish sauce (patis). Let it boil for another 2 minutes, then taste the broth to ensure it has a deep, savory balance.

Step 8 — Wilt the Greens: Arrange the cabbage wedges and pechay stalks into the bubbling broth. Cook for a final 2 to 3 minutes until the greens are wilted but still bright and crisp, then ladle hot into a large communal bowl.''',
    ),

    // 3. Caldereta
    Recipe(
      id: 'fil_003',
      name: 'Caldereta',
      category: 'Main Course',
      area: 'Batangas',
      thumbnail: 'assets/caldereta.jpg',
      tags: 'Beef,Tomato,Stew',
      ingredients: [
        Ingredient(name: 'Beef brisket or chuck', measure: '1 kg, cut into 2-inch cubes'),
        Ingredient(name: 'Potatoes', measure: '2 medium, peeled and cubed'),
        Ingredient(name: 'Carrot', measure: '1 large, peeled and cubed'),
        Ingredient(name: 'Red bell pepper', measure: '1 medium, sliced'),
        Ingredient(name: 'Green bell pepper', measure: '1 medium, sliced'),
        Ingredient(name: 'Tomato sauce', measure: '1 can (250g)'),
        Ingredient(name: 'Liver spread', measure: '1 can (85g)'),
        Ingredient(name: 'Garlic', measure: '3 cloves, minced'),
        Ingredient(name: 'Onion', measure: '1 medium, chopped'),
        Ingredient(name: 'Cooking oil', measure: '2 tbsp'),
        Ingredient(name: 'Beef broth or water', measure: '2 cups'),
        Ingredient(name: 'Salt and pepper', measure: 'to taste'),
      ],
      instructions: '''Step 1 — Prep Vegetables: Peel and cube the potatoes and carrots uniformly. Slice the red and green bell peppers into uniform strips and set them aside.

Step 2 — Sauté the Base: Heat 2 tablespoons of oil in a heavy-bottomed pot over medium heat. Sauté the minced garlic and chopped onions until fragrant and soft.

Step 3 — Sear the Beef: Add the cubed beef brisket or chuck to the pot. Cook for 5 to 8 minutes, turning the pieces occasionally, until all sides are nicely browned to lock in the juices.

Step 4 — Pour Braising Liquid: Pour the tomato sauce and 2 cups of beef broth (or water) into the pot. Stir to combine with the seared meat.

Step 5 — Simmer Until Soft: Bring the liquid to a boil, then turn the heat down to low. Cover the pot and simmer patiently for 1 to 1.5 hours until the beef yields easily to a fork.

Step 6 — Melt Liver Spread: Stir in the liver spread until it completely dissolves into the braising liquid. This adds a velvety, earthy depth and acts as the traditional thickening agent.

Step 7 — Boil Hard Vegetables: Toss in the chunked carrots and potatoes. Cover the pot again and let them cook for 10 to 12 minutes until they are soft and tender.

Step 8 — Add Peppers and Finish: Mix in the red and green bell peppers. Simmer uncovered for a final 3 minutes until the sauce is thick and coats the back of a spoon. Season with salt and pepper to taste before serving hot.''',
    ),

    // 4. Chicken Adobo
    Recipe(
      id: 'fil_004',
      name: 'Chicken Adobo',
      category: 'Main Course',
      area: 'Cavite',
      thumbnail: 'assets/chicken adobo.jpg',
      tags: 'Chicken,Adobo,Soy Sauce',
      ingredients: [
        Ingredient(name: 'Chicken pieces (thighs and drumsticks)', measure: '1 kg'),
        Ingredient(name: 'Soy sauce', measure: '1/2 cup'),
        Ingredient(name: 'White cane vinegar', measure: '1/3 cup'),
        Ingredient(name: 'Garlic', measure: '1 head, heavily crushed'),
        Ingredient(name: 'Dried bay leaves (laurel)', measure: '3 pieces'),
        Ingredient(name: 'Whole black peppercorns', measure: '1 tbsp'),
        Ingredient(name: 'Water', measure: '1/2 cup'),
        Ingredient(name: 'Cooking oil', measure: '2 tbsp'),
      ],
      instructions: '''Step 1 — Marinate Meat: In a large bowl, combine the chicken pieces, crushed garlic, and soy sauce. Mix well to coat the chicken and let it marinate in the refrigerator for at least 30 minutes.

Step 2 — Assemble Pot: Transfer the chicken and all of its garlic-infused marinade into a wide skillet or cooking pot.

Step 3 — Pour Acid and Spices: Pour in the white cane vinegar, water, dried bay leaves, and whole black peppercorns, arranging the chicken so it sits relatively level.

Step 4 — The No-Stir Rule: Bring the pot to a boil over medium-high heat. Do not stir the liquid for the first 5 minutes while it boils uncovered to allow the harsh, raw acidity of the vinegar to cook off naturally.

Step 5 — Cover and Simmer: Lower the heat to medium-low, cover with a tight lid, and let it simmer gently for 25 minutes until the chicken is cooked through and tender.

Step 6 — Separate and Crisp: Remove the chicken pieces from the pot with tongs, leaving the sauce behind. Heat 2 tablespoons of oil in a separate frying pan over high heat.

Step 7 — Sear the Chicken: Pan-fry the chicken pieces for 2 to 3 minutes per side until the skin develops a deeply browned, crispy texture.

Step 8 — Reduce the Gravy: Return the seared chicken back into the original pot with the sauce. Simmer uncovered over medium heat for 5 to 7 minutes until the liquid reduces to a rich, glossy coating that clings to the meat.''',
    ),

    // 5. Halo-Halo
    Recipe(
      id: 'fil_005',
      name: 'Halo-Halo',
      category: 'Dessert',
      area: 'Pampanga',
      thumbnail: 'assets/halo-halo.jpg',
      tags: 'Dessert,Cold,Summer',
      ingredients: [
        Ingredient(name: 'Finely shaved or crushed ice', measure: '2 cups'),
        Ingredient(name: 'Evaporated milk', measure: '1/2 cup'),
        Ingredient(name: 'Sweetened jackfruit (langka)', measure: '2 tbsp, shredded'),
        Ingredient(name: 'Sweetened saba bananas', measure: '2 tbsp, sliced'),
        Ingredient(name: 'Sweetened red mung beans', measure: '2 tbsp'),
        Ingredient(name: 'Sweetened white chickpeas (garbanzos)', measure: '2 tbsp'),
        Ingredient(name: 'Nata de coco (coconut gel)', measure: '2 tbsp'),
        Ingredient(name: 'Kaong (palm fruit)', measure: '2 tbsp'),
        Ingredient(name: 'Leche flan', measure: '1 thick slice'),
        Ingredient(name: 'Ube halaya (purple yam jam)', measure: '1 scoop'),
        Ingredient(name: 'Ube ice cream', measure: '1 scoop'),
      ],
      instructions: '''Step 1 — Prepare Glass: Take a tall, heavy-bottomed clear glass or a large dessert bowl to showcase the colorful layers of the dessert.

Step 2 — Layer Preservation Base: Drop 2 tablespoons each of the dense ingredients at the very bottom: the sweetened red mung beans and white chickpeas.

Step 3 — Layer Soft Fruits: Follow with 2 tablespoons each of the softer sweetened elements: sliced saba bananas and shredded jackfruit.

Step 4 — Layer Jelly Textures: Add 2 tablespoons each of the chewy components: nata de coco (coconut gel) and colorful kaong (palm fruit).

Step 5 — Pack the Shaved Ice: Fill the glass to the brim with finely shaved or crushed ice, packing it down gently so it forms a solid structure that can hold toppings.

Step 6 — Pour Evaporated Milk: Slowly pour 1/2 cup of rich evaporated milk over the shaved ice, watching it seep downward through the layers.

Step 7 — Add Premium Toppings: Carefully crown the top of the ice layer with a thick slice of creamy leche flan and a generous spoonful of ube halaya.

Step 8 — The Final Scoop: Place a large scoop of ube ice cream right at the peak of the structure. Serve immediately with a long spoon so the guest can mix all the elements thoroughly into a creamy slush before eating.''',
    ),

    // 6. Kare-Kare
    Recipe(
      id: 'fil_006',
      name: 'Kare-Kare',
      category: 'Main Course',
      area: 'Pampanga',
      thumbnail: 'assets/kare-kare.jpg',
      tags: 'Oxtail,Peanut,Stew',
      ingredients: [
        Ingredient(name: 'Oxtail or beef tripe', measure: '1 kg, cut into pieces'),
        Ingredient(name: 'Smooth peanut butter', measure: '3/4 cup'),
        Ingredient(name: 'Annatto seeds (atsuete)', measure: '1/4 cup, soaked in 1/2 cup warm water'),
        Ingredient(name: 'Toasted rice flour', measure: '1/4 cup, dissolved in 1/4 cup water'),
        Ingredient(name: 'Eggplants', measure: '2 medium, sliced diagonally'),
        Ingredient(name: 'String beans (sitaw)', measure: '1 bundle, cut into 2-inch pieces'),
        Ingredient(name: 'Bok choy (pechay)', measure: '1 bundle'),
        Ingredient(name: 'Onion', measure: '1 medium, chopped'),
        Ingredient(name: 'Garlic', measure: '4 cloves, minced'),
        Ingredient(name: 'Sautéed shrimp paste (bagoong)', measure: 'for serving'),
      ],
      instructions: '''Step 1 — Boil the Oxtail: Place the oxtail pieces in a large pot and cover with water. Bring to a boil, skim the surface foam, then lower the heat. Cover and simmer for 2 to 3 hours until the meat is completely tender.

Step 2 — Separate Broth: Strain and reserve 4 cups of the rich beef broth. Set the tenderized meat aside and discard the excess boiling water.

Step 3 — Extract Annatto Color: Rub the annatto seeds in the warm water until the liquid turns a deep orange-red color. Strain out and discard the seeds, keeping the colored water.

Step 4 — Sauté Base: In a deep pot, sauté the minced garlic and chopped onions until soft. Pour in the 4 cups of reserved beef broth and the colored annatto water, bringing it to a simmer.

Step 5 — Whisk Peanut Butter: Whisk in the smooth peanut butter until it dissolves completely into the broth. Add the tender oxtail back into the pot.

Step 6 — Thicken Sauce: Slowly pour in the toasted rice flour paste while stirring constantly. Let it simmer over low heat for 5 minutes until the sauce thickens into a velvety gravy.

Step 7 — Blanch Vegetables: In a separate pot of boiling water, blanch the eggplants, string beans, and bok choy for 2 to 3 minutes until tender-crisp. Cooking them separately keeps the peanut sauce clean and vibrant.

Step 8 — Assemble and Serve: Arrange the meat and blanched vegetables into a large serving bowl. Pour the rich peanut sauce over them and serve hot alongside a side dish of salty sautéed shrimp paste (bagoong).''',
    ),

    // 7. Laing
    Recipe(
      id: 'fil_007',
      name: 'Laing',
      category: 'Main Course',
      area: 'Bicol',
      thumbnail: 'assets/laing.jpg',
      tags: 'Coconut,Taro,Spicy',
      ingredients: [
        Ingredient(name: 'Dried taro leaves (gabi)', measure: '100g'),
        Ingredient(name: 'Thin coconut milk (gata)', measure: '4 cups'),
        Ingredient(name: 'Thick coconut cream (kakang gata)', measure: '2 cups'),
        Ingredient(name: 'Sautéed shrimp paste (bagoong alamang)', measure: '3 tbsp'),
        Ingredient(name: 'Garlic', measure: '5 cloves, minced'),
        Ingredient(name: 'Onion', measure: '1 medium, chopped'),
        Ingredient(name: 'Ginger', measure: '1 thumb-sized piece, grated'),
        Ingredient(name: 'Bird\'s eye chilies (siling labuyo)', measure: '5–6 pieces, chopped'),
      ],
      instructions: '''Step 1 — Combine Liquid Base: In a wide, deep pot, combine the 4 cups of thin coconut milk, minced garlic, chopped onion, grated ginger, shrimp paste, and chopped bird's eye chilies.

Step 2 — Blend Aromatics: Stir the liquid mixture thoroughly while cold to distribute the shrimp paste and heat before introducing the greens.

Step 3 — Layer Taro Leaves: Unravel the dried taro leaves and place them gently on top of the coconut milk mixture. Press them down very lightly with the back of a spoon so they touch the liquid.

Step 4 — The Critical No-Stir Phase: Turn the heat to medium-low and bring to a simmer. Do not stir the mixture for the first 15 to 20 minutes. Stirring raw taro leaves releases microscopic needle-like crystals that cause an intense itch in the throat.

Step 5 — Submerge Greens: Once the leaves have naturally absorbed the liquid and collapsed into the pot, you can safely stir. Push the remaining dry leaves under the liquid.

Step 6 — Slow Simmer: Lower the heat further, cover the pot loosely, and let it cook for another 10 minutes until the taro leaves are soft and dark green.

Step 7 — Pour Coconut Cream: Pour the 2 cups of thick coconut cream over the softened leaves. Leave the pot uncovered to allow the moisture to evaporate.

Step 8 — Render and Serve: Simmer uncovered, stirring occasionally, for 10 to 15 minutes until the sauce reduces drastically and becomes thick, dark, and slightly oily. Serve warm.''',
    ),

    // 8. Lumpia
    Recipe(
      id: 'fil_008',
      name: 'Lumpia',
      category: 'Appetizer',
      area: 'Manila',
      thumbnail: 'assets/lumpia.jpg',
      tags: 'Fried,Pork,Spring Roll',
      ingredients: [
        Ingredient(name: 'Lumpia wrappers', measure: '1 pack'),
        Ingredient(name: 'Ground pork', measure: '500g'),
        Ingredient(name: 'Carrot', measure: '1 medium, finely minced'),
        Ingredient(name: 'Onion', measure: '1 medium, finely chopped'),
        Ingredient(name: 'Garlic', measure: '4 cloves, finely minced'),
        Ingredient(name: 'Green scallions', measure: '1/2 cup, finely chopped'),
        Ingredient(name: 'Egg', measure: '1 large'),
        Ingredient(name: 'Salt', measure: '1 tsp'),
        Ingredient(name: 'Ground black pepper', measure: '1/2 tsp'),
        Ingredient(name: 'Cooking oil', measure: 'for deep frying'),
      ],
      instructions: '''Step 1 — Mix the Filling: In a large bowl, thoroughly combine the ground pork, finely minced carrots, chopped onion, minced garlic, and chopped green scallions.

Step 2 — Bind and Season: Crack the egg into the bowl to act as a binder, and season evenly with 1 teaspoon of salt and 1/2 teaspoon of black pepper. Mix with a spatula until uniform.

Step 3 — Position Wrapper: Lay a single lumpia wrapper flat on a clean surface in a diamond orientation (one corner pointing directly at you).

Step 4 — Portion Meat: Scoop 1 to 1.5 tablespoons of the pork mixture and place it horizontally near the bottom corner. Shape the meat into a thin, uniform log.

Step 5 — Tight Rolling: Fold the bottom corner tightly over the meat, roll upward halfway, then fold the left and right side corners inward toward the center to seal the edges.

Step 6 — Glue Shut: Continue rolling tightly to the top. Dab a small amount of water or egg white on the remaining top corner of the wrapper to glue it shut.

Step 7 — Heat Frying Oil: Fill a deep pan or wok with enough cooking oil to completely submerge the rolls. Heat over medium heat until it reaches roughly 350°F (175°C).

Step 8 — Deep Fry and Drain: Slide the lumpia into the hot oil in batches. Fry for 5 to 7 minutes, turning occasionally, until the wrappers are crispy and deep golden brown. Drain on paper towels and serve with sweet and sour sauce.''',
    ),

    // 9. Maja Blanca
    Recipe(
      id: 'fil_009',
      name: 'Maja Blanca',
      category: 'Dessert',
      area: 'Laguna',
      thumbnail: 'assets/maja blanca.jpg',
      tags: 'Coconut,Dessert,Sweet',
      ingredients: [
        Ingredient(name: 'Coconut milk (gata)', measure: '4 cups'),
        Ingredient(name: 'Cornstarch', measure: '1 cup'),
        Ingredient(name: 'Granulated sugar', measure: '3/4 cup'),
        Ingredient(name: 'Sweet corn kernels', measure: '1 can (400g), drained'),
        Ingredient(name: 'Unsalted butter', measure: '2 tbsp'),
        Ingredient(name: 'Latik (fried coconut milk curds)', measure: '1/2 cup, for topping'),
      ],
      instructions: '''Step 1 — Whisk Cold Liquid: In a large, cold cooking pot, combine the 4 cups of coconut milk, 3/4 cup of sugar, and 1 cup of cornstarch.

Step 2 — Dissolve Lumps: Whisk vigorously while the liquid is cold until the cornstarch is completely dissolved and no dry pockets remain before turning on the stove.

Step 3 — Cook on Low Heat: Place the pot over low heat. Use a silicone spatula or wooden spoon to stir the mixture continuously to prevent clumping.

Step 4 — Scrape Bottom: Pay close attention to scraping the bottom and corners of the pot, as the cornstarch will want to settle and scorch quickly.

Step 5 — Incorporate Additions: As the liquid warms up and begins to gently thicken, stir in the drained sweet corn kernels and 2 tablespoons of unsalted butter.

Step 6 — Thicken to Paste: Continue stirring constantly for 12 to 15 minutes. The mixture will transform from a liquid into a very thick, smooth, glossy paste that heavily coats your spoon.

Step 7 — Pour into Mold: Turn off the heat and immediately pour the hot pudding into a greased 8x8-inch baking dish or mold. Smooth out the top surface quickly before it cools.

Step 8 — Chill and Garnish: Allow it to cool completely at room temperature, then refrigerate for at least 2 hours to firm up. Top generously with crunchy latik (fried coconut milk curds) before slicing into squares.''',
    ),

    // 10. Menudo
    Recipe(
      id: 'fil_010',
      name: 'Menudo',
      category: 'Main Course',
      area: 'Manila',
      thumbnail: 'assets/menudo.jpg',
      tags: 'Pork,Liver,Tomato',
      ingredients: [
        Ingredient(name: 'Pork shoulder', measure: '500g, cut into 1/2-inch cubes'),
        Ingredient(name: 'Pork liver', measure: '200g, cut into 1/2-inch cubes'),
        Ingredient(name: 'Potatoes', measure: '2 medium, peeled and cubed'),
        Ingredient(name: 'Carrot', measure: '1 large, peeled and cubed'),
        Ingredient(name: 'Tomato sauce', measure: '1 can (250g)'),
        Ingredient(name: 'Raisins', measure: '1/4 cup'),
        Ingredient(name: 'Red bell pepper', measure: '1 medium, diced'),
        Ingredient(name: 'Garlic', measure: '3 cloves, minced'),
        Ingredient(name: 'Onion', measure: '1 medium, chopped'),
        Ingredient(name: 'Soy sauce', measure: '2 tbsp'),
        Ingredient(name: 'Fish sauce (patis)', measure: '1 tbsp'),
        Ingredient(name: 'Cooking oil', measure: '2 tbsp'),
        Ingredient(name: 'Water', measure: '1/2 cup'),
      ],
      instructions: '''Step 1 — Aromatic Base: Heat 2 tablespoons of oil in a deep skillet over medium heat. Sauté the minced garlic and chopped onions for 2 to 3 minutes until soft.

Step 2 — Brown the Pork: Add the cubed pork shoulder. Cook for 5 to 7 minutes, stirring occasionally, until the pork loses its pink color and browns slightly around the edges.

Step 3 — Infuse Soy: Stir in the soy sauce to coat the pork, letting it cook for 1 minute to add a deep, savory color to the meat.

Step 4 — Simmer the Stew: Pour in the tomato sauce and 1/2 cup of water. Bring to a boil, cover with a lid, and turn the heat to low. Simmer for 20 to 25 minutes until the pork is tender.

Step 5 — Add Liver and Roots: Add the cubed pork liver, potatoes, and carrots. Adding the liver at this stage ensures it cooks through perfectly without becoming tough and chalky.

Step 6 — Cook Vegetables: Keep the pot covered and simmer for another 8 to 10 minutes until the root vegetables can be easily pierced with a fork.

Step 7 — Sweet and Savory Balance: Mix in the raisins and diced red bell pepper. Simmer uncovered for 3 to 5 minutes until the sauce develops a good body and the peppers are tender-crisp.

Step 8 — Season and Serve: Taste the gravy and add the fish sauce (patis) to perfectly balance the sweetness of the raisins. Serve hot with rice.''',
    ),

    // 11. Pares
    Recipe(
      id: 'fil_011',
      name: 'Pares',
      category: 'Main Course',
      area: 'Manila',
      thumbnail: 'assets/pares.jpg',
      tags: 'Beef,Star Anise,Sweet',
      ingredients: [
        Ingredient(name: 'Beef brisket', measure: '1 kg, cut into 1.5-inch cubes'),
        Ingredient(name: 'Soy sauce', measure: '1/2 cup'),
        Ingredient(name: 'Dark brown sugar', measure: '1/2 cup'),
        Ingredient(name: 'Whole star anise', measure: '3 pieces'),
        Ingredient(name: 'Garlic', measure: '1 head, minced (half for searing, half for garnish)'),
        Ingredient(name: 'Ginger', measure: '1 thumb-sized piece, sliced'),
        Ingredient(name: 'Beef broth or water', measure: '4 cups'),
        Ingredient(name: 'Cornstarch', measure: '1 tbsp, dissolved in 2 tbsp water'),
        Ingredient(name: 'Green onions', measure: '1/2 cup, chopped for garnish'),
      ],
      instructions: '''Step 1 — Sauté Aromatics: Heat oil in a large pot over medium heat. Sauté the thin ginger strips and half of the minced garlic until fragrant.

Step 2 — Sear the Beef: Add the cubed beef brisket to the pot. Cook for 5 to 8 minutes, turning the pieces occasionally, until all sides develop a rich brown crust.

Step 3 — Pour Liquids: Pour in the 1/2 cup of soy sauce and 4 cups of beef broth or water into the pot.

Step 4 — Add Star Anise: Drop in the 3 whole star anise pods. This provides the iconic, sweet-licorice aroma that defines a true Pares.

Step 5 — Braise Until Gelatinous: Bring the liquid to a rolling boil, then cover the pot tightly with a lid and turn the heat to low. Simmer gently for 1.5 to 2 hours until the brisket is completely tender.

Step 6 — Sweeten Gravy: Uncover the pot and stir in the 1/2 cup of dark brown sugar, mixing until fully dissolved into the broth.

Step 7 — Thicken Sauce: Increase the heat slightly to medium-low and slowly pour in the cornstarch slurry while stirring. Let it bubble for 5 minutes until the sauce reduces into a thick, glossy glaze.

Step 8 — Garnish and Plate: In a separate small pan, fry the remaining garlic until golden and crispy. Spoon the sweet-savory beef into a bowl, garnish with fried garlic and green onions, and serve with garlic fried rice.''',
    ),

    // 12. Pinakbet
    Recipe(
      id: 'fil_012',
      name: 'Pinakbet',
      category: 'Main Course',
      area: 'Ilocos',
      thumbnail: 'assets/pinakbet.jpg',
      tags: 'Vegetables,Bagoong,Bitter Melon',
      ingredients: [
        Ingredient(name: 'Squash (kabalasa)', measure: '200g, cut into cubes'),
        Ingredient(name: 'Eggplant', measure: '1 large, sliced diagonally'),
        Ingredient(name: 'Ampalaya (bitter melon)', measure: '1 medium, cored and sliced'),
        Ingredient(name: 'Okra', measure: '6–8 pieces, tops trimmed'),
        Ingredient(name: 'Sitaw (string beans)', measure: '1 bundle, cut into 3-inch lengths'),
        Ingredient(name: 'Tomatoes', measure: '2 large, chopped'),
        Ingredient(name: 'Onion', measure: '1 medium, chopped'),
        Ingredient(name: 'Shrimp paste (bagoong alamang)', measure: '2 tbsp'),
        Ingredient(name: 'Cooking oil', measure: '1 tbsp'),
        Ingredient(name: 'Water', measure: '1/4 cup'),
      ],
      instructions: '''Step 1 — Sauté Aromatics: Heat 1 tablespoon of cooking oil in a wide pan or wok over medium heat. Sauté the onions and chopped tomatoes.

Step 2 — Mash Tomatoes: Use the back of your spoon to crush the tomatoes as they cook, turning them soft and jammy to release their natural sweetness.

Step 3 — Cook Shrimp Paste: Stir in the 2 tablespoons of shrimp paste. Let it fry with the tomato base for 2 minutes to eliminate any raw seafood edge.

Step 4 — Pour Water: Pour in 1/4 cup of water to create a small amount of steaming liquid at the bottom of the pan.

Step 5 — Layer Hard Vegetables: Arrange the vegetables in layers based on density. Place the dense squash cubes at the very bottom, followed by the string beans and okra.

Step 6 — The Delicate Top Layer: Place the sliced eggplant and bitter melon (ampalaya) on the very top layer. Do not stir the pot after adding the bitter melon to prevent it from releasing excessive bitterness.

Step 7 — Steam Cook: Cover the pot tightly with a lid. Lower the heat and let the vegetables steam in their own moisture and the shrimp paste vapors for 10 to 12 minutes.

Step 8 — Toss and Serve: Instead of using a spoon, occasionally lift the pot by its handles and give it a gentle shake to distribute the flavors. Serve immediately once the squash is fork-tender.''',
    ),

    // 13. Pork Adobo
    Recipe(
      id: 'fil_013',
      name: 'Pork Adobo',
      category: 'Main Course',
      area: 'Cavite',
      thumbnail: 'assets/pork adobo.jpg',
      tags: 'Pork,Adobo,Vinegar',
      ingredients: [
        Ingredient(name: 'Pork belly (liempo)', measure: '1 kg, cut into 2-inch chunks'),
        Ingredient(name: 'Soy sauce', measure: '1/2 cup'),
        Ingredient(name: 'White cane vinegar', measure: '1/3 cup'),
        Ingredient(name: 'Garlic', measure: '1 head, heavily crushed'),
        Ingredient(name: 'Dried bay leaves', measure: '3 pieces'),
        Ingredient(name: 'Whole black peppercorns', measure: '1 tbsp'),
        Ingredient(name: 'Water', measure: '1/2 cup'),
        Ingredient(name: 'Cooking oil', measure: '1 tbsp'),
      ],
      instructions: '''Step 1 — Marinate Pork: In a deep pot or bowl, combine the pork belly chunks, crushed garlic, soy sauce, whole peppercorns, and bay leaves. Let it marinate for 30 minutes to infuse the fat layers.

Step 2 — Pour Liquids: Add the white cane vinegar and 1/2 cup of water directly into the pot with the marinated pork.

Step 3 — The Acid Rule: Bring the mixture to a rolling boil over medium-high heat. Leave the pot uncovered and do not stir for the first 5 minutes to let the sharp, raw alcohol taste of the vinegar evaporate.

Step 4 — Low Simmer: Cover the pot with a tight lid, turn the heat to low, and simmer for 35 to 45 minutes until the pork belly is completely tender and the fat looks translucent.

Step 5 — Separate Meat: Use tongs to lift the pork pieces out of the liquid and set them aside on a plate, leaving the sauce behind in the pot.

Step 6 — Crisp the Edges: Heat 1 tablespoon of cooking oil in a separate skillet over high heat. Quick-fry the pork belly chunks for 3 minutes until the edges are crispy and browned.

Step 7 — Reduce the Sauce: Pour the reserved adobo liquid from the pot back over the crispy pork chunks in the skillet.

Step 8 — Glaze and Serve: Simmer uncovered over medium heat for 5 minutes until the sauce reduces into a thick, glossy concentrate that clings to the meat. Serve hot over rice.''',
    ),

    // 14. Puto
    Recipe(
      id: 'fil_014',
      name: 'Puto',
      category: 'Snack',
      area: 'Laguna',
      thumbnail: 'assets/puto.jpg',
      tags: 'Steamed,Rice Cake,Snack',
      ingredients: [
        Ingredient(name: 'All-purpose flour', measure: '2 cups'),
        Ingredient(name: 'Granulated sugar', measure: '1 cup'),
        Ingredient(name: 'Baking powder', measure: '1 tbsp'),
        Ingredient(name: 'Evaporated milk', measure: '1 cup'),
        Ingredient(name: 'Egg', measure: '1 large'),
        Ingredient(name: 'Unsalted butter, melted', measure: '2 tbsp'),
        Ingredient(name: 'Water', measure: '1/2 cup'),
        Ingredient(name: 'Cheddar cheese, sliced', measure: '1/2 cup, for topping'),
      ],
      instructions: '''Step 1 — Sift Dry Base: In a large bowl, sift together the 2 cups of all-purpose flour, 1 cup of sugar, and 1 tablespoon of baking powder to remove any lumps.

Step 2 — Mix Wet Base: Make a well in the center of the dry ingredients and pour in the evaporated milk, water, egg, and melted butter.

Step 3 — Whisk Batter: Whisk gently starting from the middle and moving outward until the batter is completely smooth. Do not over-whisk, or the puto will become dense instead of fluffy.

Step 4 — Fill Molds: Lightly grease your puto molds with a tiny bit of melted butter. Pour the batter into each mold, filling them only 3/4 full to leave room for the cakes to rise.

Step 5 — Prep Steamer Lid: Bring water to a rolling boil in your steamer base. Wrap the steamer lid with a clean kitchen towel to catch condensation.

Step 6 — Steam Cakes: Place the filled molds onto the steamer rack, cover tightly with the wrapped lid, and steam over medium heat for 15 minutes.

Step 7 — Add Cheese Topping: Quickly lift the lid, place a rectangle of cheddar cheese on top of each steaming cake, cover again, and steam for an additional 2 minutes until melted.

Step 8 — Cool and Unmold: Remove from the steamer and let them cool down for 5 minutes. Gently press the sides of the molds to pop the warm cakes out, and serve.''',
    ),

    // 15. Sinigang
    Recipe(
      id: 'fil_015',
      name: 'Sinigang',
      category: 'Soup',
      area: 'Manila',
      thumbnail: 'assets/sinigang.jpg',
      tags: 'Pork,Sour,Soup',
      ingredients: [
        Ingredient(name: 'Pork ribs or pork belly chunks', measure: '1 kg'),
        Ingredient(name: 'Tamarind soup base mix (sinigang mix)', measure: '1 pack (22g)'),
        Ingredient(name: 'Tomatoes', measure: '2 large, quartered'),
        Ingredient(name: 'Onion', measure: '1 medium, quartered'),
        Ingredient(name: 'Radish (labanos)', measure: '1 medium, sliced into rounds'),
        Ingredient(name: 'Long eggplant', measure: '1, sliced diagonally'),
        Ingredient(name: 'Kangkong (water spinach)', measure: '1 bundle'),
        Ingredient(name: 'Long green chilies (siling haba)', measure: '3 pieces'),
        Ingredient(name: 'Water', measure: '8 cups'),
        Ingredient(name: 'Fish sauce (patis)', measure: 'to taste'),
      ],
      instructions: '''Step 1 — Boil the Pork: Place the pork ribs or belly into a large soup pot and pour in 8 cups of water or rice-washing water.

Step 2 — Skim the Broth: Bring to a boil over high heat. Carefully skim away any gray foam that surfaces to maintain a clean flavor base.

Step 3 — Tenderize Meat: Lower the heat to medium-low, cover with a lid, and simmer for 45 minutes until the pork is tender.

Step 4 — Add Aromatics: Drop the quartered tomatoes and onions into the pot. Cook covered for 5 minutes until they soften and release their juices into the broth.

Step 5 — Simmer Root Crops: Slide the radish slices and long green chilies into the pot. Simmer for 5 minutes until the radish begins to turn translucent.

Step 6 — Sour the Broth: Pour in the tamarind soup mix, stirring well until fully dissolved. Season with a splash of fish sauce (patis) to balance the sharp sour notes.

Step 7 — Cook Vegetables: Add the eggplant slices and the thicker kangkong stalks into the bubbling pot, cooking them for 3 minutes.

Step 8 — The Carryover Wilt: Turn off the stove completely, scatter the delicate kangkong leaves on top, and cover the pot with the lid. Let it sit undisturbed off the heat for 2 minutes to gently steam the greens before serving.''',
    ),

    // 16. Sisig
    Recipe(
      id: 'fil_016',
      name: 'Sisig',
      category: 'Main Course',
      area: 'Pampanga',
      thumbnail: 'assets/sisig.jpg',
      tags: 'Pork,Sizzling,Calamansi',
      ingredients: [
        Ingredient(name: 'Pork face (ears and snout) or pork belly', measure: '1 kg'),
        Ingredient(name: 'Chicken livers', measure: '2 large'),
        Ingredient(name: 'Red onions', measure: '2 medium, finely chopped'),
        Ingredient(name: 'Bird\'s eye chilies (siling labuyo)', measure: '3–5 pieces, finely chopped'),
        Ingredient(name: 'Fresh calamansi juice', measure: '3 tbsp'),
        Ingredient(name: 'Soy sauce', measure: '2 tbsp'),
        Ingredient(name: 'Unsalted butter', measure: '2 tbsp'),
        Ingredient(name: 'Mayonnaise', measure: '2 tbsp'),
        Ingredient(name: 'Salt and black pepper', measure: 'to taste'),
        Ingredient(name: 'Raw egg', measure: '1, optional for serving'),
      ],
      instructions: '''Step 1 — Boil Pork Face: Place the pork face or pork belly in a pot of salted water with peppercorns. Boil for 45 minutes until tender, then drain and pat completely dry.

Step 2 — Cook Chicken Liver: In a separate small pan, quickly pan-fry the chicken livers until fully cooked. Finely chop them into a paste and set aside.

Step 3 — Grill to Crisp: Place the boiled and dried pork under an oven broiler or over hot charcoal. Grill until the skin becomes blistered, charred, and crispy.

Step 4 — The Fine Chop: Transfer the crispy pork to a sturdy cutting board. Using a sharp knife, chop the meat and skin into very fine, tiny cubes.

Step 5 — Sauté Aromatics: Melt 2 tablespoons of butter in a wide skillet over medium-high heat. Sauté the finely chopped red onions and chopped bird's eye chilies for just 1 minute.

Step 6 — Toss the Meat: Add the finely chopped pork and the chopped chicken livers into the skillet with the aromatics. Stir-fry vigorously for 5 to 7 minutes.

Step 7 — Season and Mix: Pour in the soy sauce, fresh calamansi juice, and a generous amount of black pepper. Turn off the heat and fold in the mayonnaise until evenly incorporated.

Step 8 — Sizzling Presentation: If using a cast-iron sizzling plate, heat it until smoking, melt a little butter on it, and pile the Sisig on top. Crack a raw egg in the center and serve immediately while crackling.''',
    ),

    // 17. Tinola
    Recipe(
      id: 'fil_017',
      name: 'Tinola',
      category: 'Soup',
      area: 'Manila',
      thumbnail: 'assets/tinola.jpg',
      tags: 'Chicken,Ginger,Soup',
      ingredients: [
        Ingredient(name: 'Chicken pieces', measure: '1 kg'),
        Ingredient(name: 'Green papaya or chayote', measure: '1 small, cut into wedges'),
        Ingredient(name: 'Chili leaves (dahon ng sili) or malunggay', measure: '1 cup'),
        Ingredient(name: 'Ginger', measure: '2 thumb-sized pieces, sliced into matchsticks'),
        Ingredient(name: 'Garlic', measure: '4 cloves, minced'),
        Ingredient(name: 'Onion', measure: '1 medium, chopped'),
        Ingredient(name: 'Fish sauce (patis)', measure: '2 tbsp'),
        Ingredient(name: 'Water or rice-washing water', measure: '6 cups'),
        Ingredient(name: 'Cooking oil', measure: '1 tbsp'),
      ],
      instructions: '''Step 1 — Sauté Ginger Base: Heat 1 tablespoon of cooking oil in a deep soup pot over medium heat. Sauté the ginger matchsticks and minced garlic for 2 to 3 minutes until highly aromatic.

Step 2 — Sear the Chicken: Add the chopped onions and chicken pieces to the pot. Stir-fry for 5 to 7 minutes until the outside of the chicken turns opaque and loses its raw color.

Step 3 — Infuse Fish Sauce: Pour in the 2 tablespoons of fish sauce (patis), stirring it around to coat the chicken. Let it cook for 1 minute to lock in the savory flavor.

Step 4 — Pour Cooking Liquid: Pour in the 6 cups of water or rice-washing water. Bring the liquid to a rolling boil over high heat.

Step 5 — Skim and Clean: Carefully skim off any surface impurities or foam that rises to the top to ensure a clean, comforting broth profile.

Step 6 — Simmer Until Cooked: Cover the pot with a lid and turn the heat down to low. Simmer gently for 20 to 25 minutes until the chicken is thoroughly cooked through.

Step 7 — Boil Green Papaya: Add the green papaya wedges (or chayote) into the broth. Simmer covered for another 8 minutes until the wedges are translucent and tender when pierced with a fork.

Step 8 — Steep the Greens: Taste the broth, adjust with salt if needed, then turn off the heat completely. Scatter the fresh chili leaves on top, cover immediately with the lid, and let it sit for 2 minutes to steam the leaves before serving.''',
    ),

    // 18. Ube Halaya
    Recipe(
      id: 'fil_018',
      name: 'Ube Halaya',
      category: 'Dessert',
      area: 'Bohol',
      thumbnail: 'assets/ube halaya.jpg',
      tags: 'Purple Yam,Dessert,Sweet',
      ingredients: [
        Ingredient(name: 'Raw purple yam (ube)', measure: '1 kg'),
        Ingredient(name: 'Sweet condensed milk', measure: '1 can (370ml)'),
        Ingredient(name: 'Thick coconut milk (gata)', measure: '1 can (400ml)'),
        Ingredient(name: 'Unsalted butter', measure: '1/2 cup'),
        Ingredient(name: 'Granulated sugar', measure: '1/2 cup'),
        Ingredient(name: 'Vanilla extract', measure: '1 tsp (optional)'),
      ],
      instructions: '''Step 1 — Boil Purple Yams: Wash the raw purple yams thoroughly to remove dirt. Boil them in a large pot of water with their skins on for 35 to 45 minutes until soft to the center.

Step 2 — Peel and Mash: Let them cool, peel away the skin, and pass the purple flesh through a fine grater or potato ricer to remove any fibrous lumps.

Step 3 — Combine Liquid Ingredients: In a large, deep, non-stick pan or wok, combine the smooth mashed ube, condensed milk, coconut milk, sugar, and vanilla extract.

Step 4 — Whisk to Paste: Whisk the ingredients together thoroughly while cold until it forms a uniform, smooth purple paste without any dry streaks.

Step 5 — Continuous Stirring: Place the pan over low heat. You must stir this mixture continuously using a sturdy wooden spoon or silicone spatula to prevent the sugars from scorching.

Step 6 — Watch it Cook Down: Cook and stir continuously for 35 to 45 minutes. The mixture will slowly lose its moisture and transform from a loose paste into a heavy, elastic dough.

Step 7 — Incorporate Butter: Once the dough pulls away cleanly from the sides of the pan, stir in the 1/2 cup of unsalted butter during the final 5 minutes of cooking.

Step 8 — Mold and Cool: Turn off the heat and immediately pack the hot halaya into containers or molds that have been lightly greased with melted butter. Smooth the top surface down and let it chill in the refrigerator before slicing.''',
    ),
  ];

  // ─── Categories ─────────────────────────────────────────────────────────────

  static final List<Category> _categories = [
    Category.local(id: 'cat_all', name: 'All'),
    Category.local(id: 'cat_main', name: 'Main Course'),
    Category.local(id: 'cat_soup', name: 'Soup'),
    Category.local(id: 'cat_dessert', name: 'Dessert'),
    Category.local(id: 'cat_appetizer', name: 'Appetizer'),
    Category.local(id: 'cat_snack', name: 'Snack'),
  ];

  // ─── Public API ──────────────────────────────────────────────────────────────

  /// Returns all 18 Filipino recipes.
  static List<Recipe> getAll() => List.unmodifiable(_all);

  /// Returns available categories.
  static List<Category> getCategories() => List.unmodifiable(_categories);

  /// Returns a recipe by its ID, or null if not found.
  static Recipe? getById(String id) {
    try {
      return _all.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Case-insensitive search across recipe name and ingredient names.
  static List<Recipe> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return getAll();
    return _all.where((r) {
      if (r.name.toLowerCase().contains(q)) return true;
      return r.ingredients.any((i) => i.name.toLowerCase().contains(q));
    }).toList();
  }

  /// Filter by category name. 'All' (or empty string) returns everything.
  static List<Recipe> filterByCategory(String category) {
    final cat = category.trim();
    if (cat.isEmpty || cat.toLowerCase() == 'all') return getAll();
    return _all.where((r) => r.category == cat).toList();
  }

  /// Returns a shuffled subset of recipes for the featured/home screen carousel.
  static List<Recipe> getFeatured({int count = 6}) {
    final shuffled = List<Recipe>.from(_all)..shuffle(Random());
    return shuffled.take(count).toList();
  }
}
