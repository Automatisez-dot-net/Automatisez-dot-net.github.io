// Point d'entrée: la fonction appelée par la règle au lancement du script
//
function performMailActionWithMessages(messageList) {
  // Garde une référence sur l'application courante (Mail)
	let app = Application.currentApplication();
	app.includeStandardAdditions = true;
	
	// Expression régulière pour les documents PDF
	let urlRE = /https?:\/\/[^\s]+\.pdf/g;

	// Liste des URLs identifiés dans la liste de messages
	let foundURL = [];

	// Cherche une URL désignant un PDF dans le texte du message
  messageList.forEach((message) => {
	  // Récupère le contenu sous forme de text enrichi
		// et cherche toutes les correspondance avec l'expression régulière
		let matches = computeAllMatches(message.content(), urlRE);
		
		matches.forEach((result) => {
		  let url = result[0];
			foundURL.push(url);
			downloadFileAt(url);
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
	  // Si aucun lien vers un PDF n'a été trouvé, affiche un message
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
	  // Catalinaet plus
		allMatches = [... text.matchAll(regex)];
	}
	else {
	  // Avant macOS 10.15 Catalina
		while ( null !== (matches = regex.exec(text)) ) {
			allMatches.push(matches);
		}
	}
	
	return allMatches;
}


// Utilise Safari pour télécharger le fichier à l'URL indiquée
//
function downloadFileAt(url) {
  let safariApp = Application("Safari");
  safariApp.includeStandardAdditions = true;

	safariApp.activate();
  safariApp.openLocation(url);
}


