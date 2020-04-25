// Point d'entrée: la fonction appelée par la règle au lancement du script
//
function performMailActionWithMessages(messageList) {
	// Garde une référence sur l'application courante (Mail)
	let app = Application.currentApplication();
	app.includeStandardAdditions = true;

	// Expression régulière pour les documents PDF
	let urlRE = /https?:\/\/[^\s]+\/([^\/\s]+\.pdf)/g;

	// Dossier de l'utilisateur
	let downloadsFolder = app.pathTo("downloads folder", {as: "alias"}).toString();


  // To debug this script, uncomment the line bellow and
	// enable "Automatically show Web Inspector for JSContexts" option 
	// in the Safari/Develop/<Computer> menu.
  // debugger;
	let foundURL = [];
	let errors = {};

	// Cherche une URL désignant un PDF dans le texte du message
  messageList.forEach((message) => {
	  // Récupère le contenu sous forme de text enrichi
	  let content = message.content();
		
		// Cherche toutes les correspondance avec l'expression régulière
		let matches = computeAllMatches(content, urlRE);
		
		// Pour chaque correspondance d'URL…
		matches.forEach((result) => {
		  let url  = result[0];
			let name = result[1]; 
			foundURL.push(url);
			
			downloadFileAt(url, downloadsFolder, name);
		});
	});
	
	// Les téléchargements sont lancés, affiche un message avec la liste des message
	
	if ( foundURL.length > 0 ) {
		app.displayDialog(`PDF identifiés:\n— ` + foundURL.join(' ;\n— '), { 
			buttons: [ "OK" ],
			defaultButton: 1,
			withIcon: "note",
			givingUpAfter: 15
	  });
	}
	else {
		app.displayDialog(`Aucun PDF identifié.`, { 
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


// Utilise Safari pour télécharger le fichier à l'URL indiquée
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


