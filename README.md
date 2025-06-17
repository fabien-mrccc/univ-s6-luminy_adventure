# Luminy Adventure

**Luminy Adventure** is a solo immersive video game developed with the Godot Engine. Players can freely explore the Luminy campus and complete various missions through mini-games. This project was created as part of a university assignment by a team of five.

## Overview

The player will be able to navigate the Luminy campus. While exploring, they will encounter interactive locations and access different mini-games. A built-in to-do list tracks progress. There is no required order for completing tasks, the experience is fully non-linear.

## Controls

- **Move Forward**: Z  
- **Move Backward**: S  
- **Move Left**: Q  
- **Move Right**: D  
- **Sprint**: Shift + direction key  
- **Interact**: E (when the interaction prompt appears)  
- **Click buttons in mini-games**: Left mouse click  

## How to Run the Project

1. Clone the repository:  
   `git clone https://github.com/fabien-mrccc/univ-s6-luminy_adventure.git`

2. Open the project with [Godot Engine](https://godotengine.org/).  
3. Launch the main scene `game.tscn` by clicking **Run Project**.

## Available Missions

- **Attend a class**: Answer multiple-choice questions from a teacher in a classroom.
- **Drive around Luminy**: A time trial race around the campus.
- **Work at the CROUS reception**: Check student documents and decide who can enter the building.
- **Survive a manga**: A branching narrative game with decisions and consequences.
- **Find Luminy's plants**: Identify and collect local flora such as cistus, Montpellier aphyllanthe, and dubious daffodils.

## Technologies Used

- **Game Engine**: Godot Engine  
- **Unit Testing**: Godot Unit Test (GUT)  
- **3D Modeling & Animation**: Blender  
- **2D Artwork**: Procreate  
- **Version Control**: GitHub  

## Project Structure

The main scene is `game.tscn`, which contains the full campus map. All mini-games are accessible from this scene through in-game triggers.

## Testing

Unit tests were created using the GUT framework to verify the main gameplay mechanics and each mini-game. 

## Authors

- Fabien Marcuccini  
- Amina Fanani  
- Batiste Borg  
- Imad Mouffok  
- Salim Ahmed

## License

Academic project – Aix-Marseille University – 2025
