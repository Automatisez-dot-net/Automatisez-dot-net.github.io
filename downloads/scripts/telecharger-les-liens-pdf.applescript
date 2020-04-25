// Point d'entr�e: la fonction appel�e par la r�gle au lancement du script
//
function performMailActionWithMessages(messageList) {
  // Garde une r�f�rence sur l'application courante (Mail)
	let app = Application.currentApplication();
	app.includeStandardAdditions = true;
	
	// Expression r�guli�re pour les documents PDF
	let urlRE = /https?:\/\/[^\s]+\.pdf/g;

	// Liste des URLs identifi�s dans la liste de messages
	let foundURL = [];

	// Cherche une URL d�signant un PDF dans le texte du message
  messageList.forEach((message) => {
	  // R�cup�re le contenu sous forme de text enrichi
		// et cherche toutes les correspondance avec l'expression r�guli�re
		let matches = computeAllMatches(message.content(), urlRE);
		
		matches.forEach((result) => {
		  let url = result[0];
			foundURL.push(url);
			downloadFileAt(url);
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
	  // Si aucun lien vers un PDF n'a �t� trouv�, affiche un message
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


// Utilise Safari pour t�l�charger le fichier � l'URL indiqu�e
//
function downloadFileAt(url) {
  let safariApp = Application("Safari");
  safariApp.includeStandardAdditions = true;

	safariApp.activate();
  safariApp.openLocation(url);
}


