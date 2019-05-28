ICART Béranger
# DUT Info 1 - Programmation Base de données

Suivez les instructions de votre enseignant pour installer et lancer le wiki FitNesse / DBFit.
Une fois le wiki lancé, rendez-vous à l'adresse suivante pour obtenir toutes les informations relatives aux activités à réaliser en TP :
http://localhost:8085/ProgrammationBD

Etape8:
	- Lorsque l'on tente d'afficher la page ./fixActivities:
		- modifier ActivityController pour trouver quand on cherche à accéder à cette page avec @GetMapping("fixActivities")
	- Lancer la fonction fix_activities_without_owner(),
		- dans ActivityController: appeler cette fonction à partir du modèle ActivityDAOService
		- dans le modèle ActivityDAOService , appeler cette fonction
	- Afficher la page d'activité rafraîchie
		- dans ActivityController, return "index" pour rafraîchir la page index, et ne pas aller sur la page ./fixActivities
		
		
Etape9:
	- Créer un rôle avec un mot de passe:
		CREATE ROLE myactivities WITH LOGIN PASSWORD 'm7@ct1v1t135'
		
	- Rôle devient propriétaire de la base de données
		. Autoriser la connexion à la base de données
			GRANT CONNECT ON DATABASE "myactivities-test" TO myactivities
		. Donner tous les privilèges sur toutes les tables
			GRANT ALL ON ALL TABLES IN SCHEMA public TO myactivities
		. Et sur toutes les séquences
			GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO myactivities