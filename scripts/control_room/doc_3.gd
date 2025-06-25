extends Control

# === Student Information ===
@export var nom: String = "Désinfectine"
@export var prenom: String = "Cléopâtre"
@export var date_naissance: String = "14/07/1997"

# === Dialogue Text ===
@export var dialogue_entrée: String = "Bonjour. Je suis Désinfectine Cléopâtre, Responsable Administrative Officielle du Gel Hydroalcoolique du 
Campus de Luminy. Ma mission, confiée par le Comité Interfacultaire de Salubrité 
Hygiénique Extraordinaire, est d'assurer la pureté antiseptique de tout contact manuel.
Voici ma carte officielle certifiée conforme ISO 9999-GEL. Je demande l'accès immédiat afin d'inspecter 
vos poignées de porte."

@export var dialogue_accepté: String = "Excellente décision. Ce poste va enfin briller d'une hygiène irréprochable."

@export var dialogue_refusé: String = "Quoi ?! Vous refusez l'accès à l'agent désinfecteur ? Attendez-vous à une inspection surprise... très surprise."

# ===Flags ===
@export var should_be_accepted: bool = false
