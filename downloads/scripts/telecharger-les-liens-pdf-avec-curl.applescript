// Point d'entr�e: la fonction appel�e par la r�gle au lancement du script
//
function performMailActionWithMessages(messageList) {
	// Garde une r�f�rence sur l'application courante (Mail)
	let app = Application.currentApplication();
	app.includeStandardAdditions = true;

	// Expression r�guli�re pour les documents PDF
	let urlRE = /https?:\/\/[^\s]+\/([^\/\s]+\.pdf)/g;

	// Dossier de l'utilisateur
	let downloadsFolder = app.pathTo("downloads folder", {as: "alias"}).toString();


  // To debug this script, uncomment the line bellow and
	// enable "Automatically show Web Inspector for JSContexts" option 
	// in the Safari/Develop/<Computer> menu.
  // debugger;
	let foundURL = [];
	let errors = {};

	// Cherche une URL d�signant un PDF dans le texte du message
  messageList.forEach((message) => {
	  // R�cup�re le contenu sous forme de text enrichi
	  let content = message.content();
		
		// Cherche toutes les correspondance avec l'expression r�guli�re
		let matches = computeAllMatches(content, urlRE);
		
		// Pour chaque correspondance d'URL�
		matches.forEach((result) => {
		  let url  = result[0];
			let name = result[1]; 
			foundURL.push(url);
			
			downloadFileAt(url, downloadsFolder, name);
		});
	});
	
	// Les t�l�chargements sont lanc�s, affiche un message avec la liste des message
	
	if ( foundURL.length > 0 ) {
		app.displayDialog(`PDF identifi�s:\n��` + foundURL.join(' ;\n��'), { 
			buttons: [ "OK" ],
			defaultButton: 1,
			withIcon: "note",
			givingUpAfter: 15
	  });
	}
	else {
		app.displayDialog(`Aucun PDF identifi�.`, { 
			buttons: [ "OK" ],
			defaultButton: 1,
			withIcon: "note",
			givingUpAfter: 15
	  });
	}
}


// Construit un tabbleau avec toutes les correspondances
// et les groupes
//
function computeAllMatches(text, regex) {
  let allMatches = [];
	
	if ( !!text.matchAll ) {
	  // Catalina and above
		allMatches = [... text.matchAll(regex)];
	}
	else {
	  // Before macOS 10.15 Catalina
		while ( null !== (matches = regex.exec(text)) ) {
			allMatches.push(matches);
		}
	}
	
	return allMatches;
}


// Utilise Safari pour t�l�charger le fichier � l'URL indiqu�e
//
function downloadFileAt(url, destination, filename) {
  let terminalApp = Application("Terminal");
  terminalApp.includeStandardAdditions = true;

	let commands = [
	  `cd`,
		`curl "${ url }\" -o "${ destination }/${ filename }"`,
		`exit`
	];
	
	terminalApp.activate();
  terminalApp.doScript(commands.join(" ; "));
}


