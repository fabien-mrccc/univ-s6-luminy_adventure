# 🇫🇷 Luminy Adventure (english version below)

## Présentation du jeu

Luminy Adventure est un jeu vidéo immersif solo qui permet d’explorer librement le campus de Luminy (Marseille) à travers une série de mini-jeux répartis dans l’environnement. Une to-do list vous guide dans les différentes activités à accomplir.

### Activités disponibles

* Participer à un cours : Répondez à des questions sur le campus.
* Faire le tour du campus en voiture : Terminez un circuit chronométré.
* Travailler à l’accueil du CROUS : Vérifiez les documents d’étudiants.
* Survivre dans un manga : Résolvez une enquête narrative.
* Découvrir la botanique des calanques : Collectez des plantes typiques.

### Contrôles

| Action             | Touche            |
| ------------------ | ----------------- |
| Déplacer la caméra | Souris            |
| Avancer            | Z                 |
| Reculer            | S                 |
| Gauche             | Q                 |
| Droite             | D                 |
| Courir             | Shift + ZQSD      |
| Interagir          | E (quand affiché) |
| Clic bouton        | Clic gauche       |

### Lancer le jeu

Téléchargez l’exécutable correspondant à votre plateforme (Windows/macOS), puis double-cliquez pour démarrer.

### Progression

Les mini-jeux peuvent être joués dans n’importe quel ordre. Votre progression est sauvegardée automatiquement.

---

## Pour les développeurs

### Structure du projet

* addons/ : Plugins Godot (ex. GUT)
* assets/ : Ressources visuelles et audio
* scenes/ : Scènes du jeu
* scripts/ : Scripts GDScript
* shaders/ : Shaders visuels
* tests/ : Tests unitaires GUT

La scène par défaut est **world.tscn**.

### Lancer dans Godot

* Cloner le dépôt :
  `git clone https://github.com/fabien-mrccc/univ-s6-luminy_adventure.git`
* Ou télécharger le .zip depuis GitHub.
* Importer le dossier dans Godot.
* Cliquer sur **Run Project** pour lancer le jeu.

### Lancer les tests

* Activer GUT dans **Project > Project Settings > Plugins**.
* Ouvrir l’onglet GUT (en bas de l’écran).
* Cliquer sur **Run All** pour exécuter tous les tests.

Si aucun test ne se lance, assurez-vous que le dossier `res://tests` est bien présent dans l’option “Include Subdirs” de GUT (fenêtre à droite).

## Auteurs

- Fabien MARCUCCINI
- Amina FANANI
- Batiste BORG
- Imad MOUFFOK
- Salim AHMED

## Licence

Projet académique – Aix-Marseille Université – 2025

---

# 🇬🇧 Luminy Adventure

## Game Overview

Luminy Adventure is a single-player immersive video game that lets you freely explore the Luminy campus (Marseille) through a series of mini-games embedded in the environment. A to-do list helps you track the available activities.

### Available Activities

* Attend a class: Answer questions about the campus.
* Drive around campus: Complete a timed lap.
* Work at the CROUS front desk: Check student documents.
* Survive inside a manga: Solve a narrative mystery.
* Discover calanques botany: Collect local plant species.

### Controls

| Action       | Key            |
| ------------ | -------------- |
| Move camera  | Mouse          |
| Move forward | Z              |
| Move back    | S              |
| Move left    | Q              |
| Move right   | D              |
| Run          | Shift + ZQSD   |
| Interact     | E (when shown) |
| UI click     | Left click     |

### Launch the Game

Download the executable for your platform (Windows/macOS) and double-click to start.

### Progression

Mini-games can be completed in any order. Your progress is saved automatically.

---

## For Developers

### Project Structure

* addons/ : Godot plugins (e.g. GUT)
* assets/ : Visual and audio resources
* scenes/ : Game scenes
* scripts/ : GDScript scripts
* shaders/ : Visual shaders
* tests/ : GUT unit tests

The default scene is **world.tscn**.

### Run in Godot

* Clone the repository:
  `git clone https://github.com/fabien-mrccc/univ-s6-luminy_adventure.git`
* Or download the .zip from GitHub.
* Import the project folder into Godot.
* Click **Run Project** to launch the game.

### Run Unit Tests

* Enable GUT in **Project > Project Settings > Plugins**.
* Open the GUT tab (at the bottom of the editor).
* Click **Run All** to execute all tests.

If no tests run, make sure the `res://tests folder` is present and included in GUT’s “Include Subdirs” option (panel on the right).

## Authors

- Fabien MARCUCCINI
- Amina FANANI
- Batiste BORG
- Imad MOUFFOK
- Salim AHMED

## License

Academic project – Aix-Marseille University – 2025
