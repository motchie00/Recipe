# Pinas Sarap - Mobile App Guide

Ang guide na ito ay nagpapaliwanag kung paano gumagana ang recipe mobile app at ang mga tools na ginamit natin para binuo ito.

---

## The Tech Stack (Paano ito binuo)
- **Frontend (App)**: Gawa sa **Flutter (Dart)** para sa maganda, smooth, at responsive na user interface na may vintage-inspired color theme.
- **Backend (Server)**: Powered by **Node.js & Express** para i-handle ang accounts, custom recipes, favorites, at feedback.
- **Database**: Gumagamit ng **MongoDB** para ligtas na i-save ang user profiles, custom recipes, at favorite/saved bookmarks.

---

## Architectural Logic (Paano naka-organize ang Code)

Binuo ang app gamit ang **Modular Architecture** (hiwalay ang itsura sa data at internet). Hati ito sa anim na folders:

1. **Services**: Ang taga-konekta sa server gamit ang internet (API calls para sa login, custom recipes, at favorites).
2. **Providers**: Ang "utak" ng app na namamahala ng recipe state, favorites list, authentication, at nag-uupdate ng screens kapag may nagbago.
3. **Models**: Ang "blueprints" na nagtatakda ng format ng data (Recipe at Ingredients).
4. **Screens**: Ang visual pages gaya ng Home Screen, Recipe Detail Screen, at Custom Recipe Builder.
5. **Widgets**: Reusable components gaya ng custom Recipe Card para sa malinis na rendering ng recipe listing.
6. **Utils**: Ang file kung saan nakatakda ang custom Vintage theme colors, typography, at shared constants.

---

### Simpleng Halimbawa kung paano sila nagtutulungan (Custom Recipe Creation)

Kapag nagdagdag ka ng sarili mong recipe:
1. **Screens (UI)**: I-tatap mo ang "+" button sa **my_recipes_screen.dart** (Add Custom Recipe), kung saan ilalagay mo ang pangalan, pinagmulang lungsod (Origin), kategorya, sangkap (Ingredients), at mga hakbang sa pagluluto (Instructions).
2. **Providers (Utak)**: Sasaluhin ng **CustomRecipesProvider** ang mga detalye at magti-trigger ng save state.
3. **Models (Blueprint)**: I-aayos ng **Recipe** at **Ingredient** model ang data para gawing malinis na structured object.
4. **Services (Internet)**: Kukunin ng **CustomRecipeService** ang object at ipadadala sa server sa pamamagitan ng `api_service.dart`.
5. **Widgets & Utils (Disenyo)**: Habang naglo-load, ipapakita ng screen ang vintage theme styles mula sa **app_theme.dart** at babalik ka sa grid page na may success popup.

-----

## Core Flutter & Material Design Widgets (Sa Simpleng Taglish)

### 1. Scaffold (Ang Screen Frame)
Nagsisilbing base frame ng bawat page (gaya ng Home at Profile) na may built-in na suporta para sa AppBar, Drawer menu, at Floating Action Button.

### 2. AppBar (Ang Header sa Taas)
Ang custom header sa taas ng screen. Sa Home Screen, ito ay naka-customize kung saan nasa kaliwa ang Drawer button, habang centered ang logo at pangalan ng app ("Pinas Sarap"). Sa Detail Screen, mayroon din itong translucent back button at bookmark action.

### 3. Drawer (Ang Slide-out Sidebar Menu)
Sidebar menu na lumalabas mula sa kaliwa. Dito nagagawa ang pag-navigate sa **Home**, **Saved Recipes**, **Profile**, **My Recipes**, **Feedback**, at pag-**Logout**.

### 4. Icons (Mga Simbolo)
Visual symbols para sa madaling pag-intindi:
- **Location/Public Icon** para sa origin city/province (e.g., Batangas, Cebu).
- **Category Icon** para sa uri ng pagkain (Main Course, Soup, Dessert, etc.).
- **Flame Icon** para sa featured/trending recipes.
- **Star Icon** para sa star rating sa feedback.

### 5. Buttons, Cards, & Inputs
- **Recipe Cards**: Magagandang Rounded cards na may thumbnail image, title, category, at origin badge.
- **Inputs (Text Fields)**: Dynamic input fields para sa pag-type ng title, custom origin, instructions, at rows ng ingredients (may dynamic add/remove rows).

### 6. Progress Indicators (Loading Screens)
- **Shimmer Loading Effect**: Kalmadong skeleton loading block habang hinihintay ang recipes mula sa server.
- **Circular Progress Spinner**: Maliit na umiikot na loading icon para sa pag-submit ng feedback at forms.

### 7. Gestures (Mga Pindot o Taps)
- **InkWell / GestureDetector**: Nagbibigay ng feedback animations kapag pinindot ang recipe cards o chips at isinasara ang keyboard kapag pinindot ang labas ng text fields.

---

## Paano Tumatakbo at Naaalala ng App ang mga Bagay

### 1. Provider (State Management)
Pinamamahalaan ng providers ang global states para laging synchronized ang data sa buong app:
- **AuthProvider**: Namamahala sa session, auto-login, at user profile.
- **RecipeProvider**: Naglo-load ng built-in recipes, categories, at controls sa search filter o homepage lists (naka-limit sa 8 visible items).
- **FavoriteProvider**: Ligtas na nag-iimbak at nagpapalit ng state ng saved/bookmarked recipes sa database.
- **CustomRecipesProvider**: Nangangasiwa sa pag-load, pag-save, pag-update (editing), at pag-delete ng iyong sariling recipes.

### 2. SharedPreferences (Shared Memory)
Tinatawagan ng `api_service.dart` para ligtas na itabi ang user login token (JWT), na ginagamit para manatiling logged-in kahit isara ang app.

---

## File Overview (Ano ang ginagawa ng bawat .dart file)

### Starting File
- **main.dart**: Ang unang pinatatakbo ng app. Dito inihahanda ang providers at tinutukoy kung anong screen ang bubuksan sa startup.

### Data at Blueprints (Folders: `lib/data/` at `lib/models/`)
- **filipino_recipes_data.dart**: Ang local source ng 18 built-in recipes na may mga nakatakdang origin (Batangas, Pampanga, etc.).
- **recipe_model.dart**: Tagapamahala ng parsing ng JSON recipe structure mula sa database at API.
- **category_model.dart**: Blueprint para sa recipe categories.

### Services at Providers (Folders: `lib/services/` at `lib/providers/`)
- **api_service.dart**: Humahawak ng mga server requests (GET, POST, PUT, DELETE) at nag-iinject ng security auth headers.
- **recipe_service.dart**: Taga-fetch ng built-in recipes at categories.
- **custom_recipe_service.dart**: Nakikipag-ugnayan sa server para sa pag-save, pag-update (edit), at pag-delete ng custom recipes.
- **auth_provider.dart**: Utak para sa login, signup, at token updates.
- **recipe_provider.dart**: Taga-manage ng homepage recipes list at pagination (shows 8 initially).
- **favorite_provider.dart**: Nagdadagdag at nag-aalis ng favorite bookmarks sa cloud.
- **custom_recipes_provider.dart**: Taga-manage ng custom user recipe actions kabilang ang runtime update propagation.

### Screen Pages (Folder: `lib/screens/`)
- **splash_screen.dart**: Unang loading screen na may animated logo at custom vintage gradient background.
- **main_navigation.dart**: Shell na naglalaman ng persistent bottom navigation bars at Drawer menu.
- **home_screen.dart**: Home page na may search bar, category modal sheet, featured slider, at recipe feed.
- **recipe_detail_screen.dart**: Detalyadong view ng recipe na nagpapakita ng banner image, categories, ingredients grid (un-overflowable row), step-by-step instructions, at quick edit action.
- **my_recipes_screen.dart**: Listahan ng custom recipes na may single-tap quick-delete, card-level edit button, at ang full `AddRecipeScreen` form.
- **saved_recipes_screen.dart**: Listahan ng lahat ng recipe na minarkahan mong "Saved".
- **profile_screen.dart**: User settings, statistics, at about description info.
- **feedback_screen.dart**: Rating page kung saan pwedeng mag-iwan ng review.
- **login_screen.dart** at **register_screen.dart**: Secure authentication pages.

### Design at Components (Folders: `lib/utils/` at `lib/widgets/`)
- **app_theme.dart**: Set ng disenyong vintage (terracotta primary, soft eggshell backgrounds, at warm dark-brown fonts).
- **recipe_card.dart**: Reusable visual block para sa compact at magandang grid view ng mga recipe.
