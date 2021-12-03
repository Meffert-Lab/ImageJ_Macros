Dialog.create("Choose Working Directory");
Dialog.addDirectory("Browse", "D:\\Users\\Xinbei\\");
Dialog.show();
thePath = Dialog.getString();

ipsiUninjSummary = File.openAsRawString(thePath + "/" + "ipsi_uninjured" + "/" + "__FQ_batch_summary_ALL_211025.txt");
ipsiUninjArray = split(ipsiUninjSummary, "\n");
ipsiUninjOrganized = newArray(ipsiUninjArray.length);
organizeVals(ipsiUninjArray, ipsiUninjOrganized);
ipsiUninjOrganized = Array.deleteValue(ipsiUninjOrganized, 0);
//Array.print(ipsiUninjOrganized);
//Array.print(ipsiUninjArray);
avgVals = newArray(ipsiUninjOrganized.length);
for (a = 0; a < ipsiUninjOrganized.length; a++) {
	//print(ipsiUninjOrganized[a].substring(ipsiUninjOrganized[a].lastIndexOf("\t"), ipsiUninjOrganized[a].length));
	avgVals[a] = parseFloat(ipsiUninjOrganized[a].substring(ipsiUninjOrganized[a].lastIndexOf("\t"), ipsiUninjOrganized[a].length));

}
//Array.print(avgVals);
ipsiInjSummary = File.openAsRawString(thePath + "/" + "ipsi_injured" + "/" + "__FQ_batch_summary_ALL_211025.txt");
ipsiInjArray = split(ipsiInjSummary, "\n");
ipsiInjOrganized = newArray(ipsiInjArray.length);
organizeVals(ipsiInjArray, ipsiInjOrganized);
ipsiInjOrganized = Array.deleteValue(ipsiInjOrganized, 0);
injuredFilenames = newArray();
for (a = 0; a < ipsiInjOrganized.length; a++) {
	injuredFilenames = Array.concat(injuredFilenames, ipsiInjOrganized[a].substring(0, ipsiInjOrganized[a].indexOf("\t")));
}
uninjuredFilenames = newArray();
for (a = 0; a < ipsiUninjOrganized.length; a++) {
	uninjuredFilenames = Array.concat(uninjuredFilenames, ipsiUninjOrganized[a].substring(0, ipsiUninjOrganized[a].indexOf("\t")));
}

for (a = 0; a < uninjuredFilenames.length; a++) {
	if (a >= injuredFilenames.length) {
		uninjuredFilenames = Array.deleteIndex(uninjuredFilenames, a);
		a--;
		continue;
	}
	if (injuredFilenames[a] != uninjuredFilenames[a]) {
		contains = false;
		for (b = a; b < injuredFilenames.length; b++) {
			if (uninjuredFilenames[a] == injuredFilenames[b]) {
				contains = true;
				break;
			}
		}
		if (contains) {
			injuredFilenames = Array.deleteIndex(injuredFilenames, a);
			a--;
			continue;
		}
		if (!contains) {
			uninjuredFilenames = Array.deleteIndex(uninjuredFilenames, a);
			a--;
		}
	}
}
lengthDiffers = true;
while (lengthDiffers) {
	if (injuredFilenames.length > uninjuredFilenames.length) {
		injuredFilenames = Array.deleteIndex(injuredFilenames, injuredFilenames.length - 1);
		continue;
	}
	if (uninjuredFilenames.length > injuredFilenames.length) {
		uninjuredFilenames = Array.deleteIndex(uninjuredFilenames, uninjuredFilenames.length - 1);
		continue;
	}
	lengthDiffers = false;
}

//Array.print(uninjuredFilenames);
//Array.print(injuredFilenames);
for (a = 0; a < uninjuredFilenames.length; a++) {
	if (ipsiInjOrganized[a].indexOf(uninjuredFilenames[a]) == -1) {
		ipsiInjOrganized = Array.deleteIndex(ipsiInjOrganized, a);
		a--;
		continue;
	}
	if (ipsiUninjOrganized[a].indexOf(uninjuredFilenames[a]) == -1) {
		ipsiUninjOrganized = Array.deleteIndex(ipsiUninjOrganized, a);
		avgVals = Array.deleteIndex(avgVals, a);
		a--;
		continue;
	}
}
lengthDiffers = true;
while (lengthDiffers) {
	if (ipsiInjOrganized.length > uninjuredFilenames.length) {
		ipsiInjOrganized = Array.deleteIndex(ipsiInjOrganized, ipsiInjOrganized.length - 1);
		continue;
	}
	if (ipsiUninjOrganized.length > uninjuredFilenames.length) {
		ipsiUninjOrganized = Array.deleteIndex(ipsiUninjOrganized, ipsiUninjOrganized.length - 1);
		continue;
	}
	lengthDiffers = false;
}
normalizedUninjured = newArray(ipsiUninjOrganized.length);
normalizeArrayToValue(ipsiUninjOrganized, avgVals, normalizedUninjured);
normalizedInjured = newArray(ipsiInjOrganized.length);
normalizeArrayToValue(ipsiInjOrganized, avgVals, normalizedInjured);
//Array.print(avgVals);
//Array.print(normalizedInjured);
ipsiInjuredFile = File.open(thePath + "/" + "ipsi_injured" + "/" + "NORMALIZED_IPSI_INJ.txt");
for (a = 0; a < normalizedInjured.length; a++) {
	print(ipsiInjuredFile, normalizedInjured[a]);
}
File.close(ipsiInjuredFile);
//Array.print(normalizedUninjured);
ipsiUninjuredFile = File.open(thePath + "/" + "ipsi_uninjured" + "/" + "NORMALIZED_IPSI_UNINJ.txt");
for (a = 0; a < normalizedUninjured.length; a++) {
	print(ipsiUninjuredFile, normalizedUninjured[a]);
}
File.close(ipsiUninjuredFile);
print("DONE");
function organizeVals (array, allCellsInFile) {

	for (i = 0; i < array.length; i++) {
		if (array[i].lastIndexOf("FILE") == -1) {
			continue;
		}
		i++;
		break;
	}
	identifier = "";
	conditionCount = 1;
	lineArray = split(array[i], "\t");
	//Array.print(lineArray);
	identifier = lineArray[0];
	//allCellsInFile = newArray(1);
	allCellsInFile[0] = identifier;
	identifierCellCount = 0;
	identifierSum = 0.0;
	for (j = i; j < array.length; j++) {
		lineArray = split(array[j], "\t");
		if (lineArray[0] != identifier) {
			//print(identifier);
			allCellsInFile[conditionCount - 1] = allCellsInFile[conditionCount - 1] + "\t" + identifierSum / identifierCellCount;
			//print(allCellsInFile[conditionCount - 1]);
			identifier = lineArray[0];
			conditionCount++;
			identifierCellCount = 0;
			identifierSum = 0;
			allCellsInFile[conditionCount - 1] = identifier;
		}
		allCellsInFile[conditionCount - 1] = allCellsInFile[conditionCount - 1] + "\t" + lineArray[3];
		identifierCellCount++;
		identifierSum += parseFloat(lineArray[3]);
	}
	allCellsInFile[conditionCount - 1] = allCellsInFile[conditionCount - 1] + "\t" + identifierSum / identifierCellCount;
	//Array.print(allCellsInFile);
}

function normalizeArrayToValue (arrayToNorm, normVals, normalizedArray) {
	for (x = 0; x < arrayToNorm.length; x++) {
		arrayLine = split(arrayToNorm[x], "\t");
		normalizedArray[x] = arrayLine[0];
		for (y = 1; y < arrayLine.length - 1; y++) {
			normalizedVal = parseFloat(arrayLine[y]) / parseFloat(normVals[x]);
			normalizedArray[x] = normalizedArray[x] + "\t" + normalizedVal;
		}
	}
}
