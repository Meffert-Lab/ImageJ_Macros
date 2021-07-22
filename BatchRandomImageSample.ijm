Dialog.create("Set Folders and Files");
Dialog.addDirectory("Cell .csv folder", "D:\\Users\\Xinbei\\");
Dialog.addDirectory("Images folder", "D:\\Users\\Xinbei\\");
Dialog.addDirectory("Outline folder", "D:\\Users\\Xinbei\\");
Dialog.show();

csvPath = Dialog.getString();
imgPath = Dialog.getString();
outlinePath = Dialog.getString();

randomIntegers = newArray(176, 122, 16, 76, 78, 102, 195, 77, 17, 51, 72, 132, 83, 152, 141, 127, 1, 126, 194, 184, 85, 171, 191, 182, 12, 15, 97, 183, 84, 158, 20, 172, 116, 13, 86, 134, 146, 2, 22, 198);

csvFolderContents = getFileList(csvPath);
for(i = 0; i < csvFolderContents.length; i++) {
	if (csvFolderContents[i].indexOf(".csv") == -1) {
		csvFolderContents = Array.deleteIndex(csvFolderContents, i);
	}
}
imgFolderContents = getFileList(imgPath);
for(i = 0; i < imgFolderContents.length; i++) {
	if (imgFolderContents[i].indexOf(".tif") == -1) {
		imgFolderContents = Array.deleteIndex(imgFolderContents, i);
	}
}
outlineFolderContents = getFileList(outlinePath);
for (i = 0; i < outlineFolderContents.length; i++) {
	if (outlineFolderContents[i].indexOf("__outline.txt") == -1) {
		outlineFolderContents = Array.deleteIndex(outlineFolderContents, i);
	}
}
for(i = 0; i < randomIntegers.length; i++) {
	randomInt = randomIntegers[i];
	csvFileContents = File.openAsRawString(csvPath + File.separator + csvFolderContents[randomInt]);
	csvFileArray = split(csvFileContents, "\n");
	maxMean = 0;
	zStack = -1;
	for (j = 1; j < csvFileArray.length; j++) {
		csvLine = split(csvFileArray[j], ",");
		if (maxMean < parseFloat(csvLine[1])) {
			maxMean = parseFloat(csvLine[1]);
			zStack = j; //z-stack starts at 1 and ends at max stack
		}
	}
	print(csvFolderContents[i]);
	open(imgPath + csvFolderContents[i].substring(0, csvFolderContents[i].indexOf("_CELL")) + ".tif");
	setSlice(zStack);
	setMetadata("Label", csvFolderContents[i].substring(csvFolderContents[i].indexOf("_CELL"), csvFolderContents[i].length) + " STACK:" + zStack);
	outlineFileContents = File.openAsRawString(outlinePath + File.separator + csvFolderContents[i].substring(0, csvFolderContents[i].indexOf("_CELL")) + "__outline.txt");
	outlineFileArray = split(outlineFileContents, "\n");
	cellNumber = 1;
	for (k = 0; k < outlineFileArray.length; k++) {
		if (outlineFileArray[k].indexOf("CELL_START") == -1) {
			continue;
		}
		lineX = outlineFileArray[k + 1];
		xCoordsString = split(lineX, "\t");
		xCoords = newArray(xCoordsString.length - 1);
		lineY = outlineFileArray[k + 2];
		yCoordsString = split(lineY, "\t");
		yCoords = newArray(yCoordsString.length - 1);
		xCoordsAvg = 0;
		yCoordsAvg = 0;
		numPoints = 0;
		xCoordsSum = 0;
		yCoordsSum = 0;
		for (l = 1; l < xCoordsString.length; l++) {
			xCoords[l-1] = parseInt(xCoordsString[l]);
			numPoints++;
		}
		for (l = 1; l < yCoordsString.length; l++) {
			yCoords[l-1] = parseInt(yCoordsString[l]);
		}
		makeSelection("polygon", xCoords, yCoords);
		Overlay.addSelection;
		if (outlineFileArray[k + 5].indexOf("Nucleus_START") != -1) {
			lineNucX = outlineFileArray[k + 6];
			nucXCoordsString = split(lineNucX, "\t");
			nucXCoords = newArray(nucXCoordsString.length - 1);
			lineNucY = outlineFileArray[k + 7];
			nucYCoordsString = split(lineNucY, "\t");
			nucYCoords = newArray(nucYCoordsString.length - 1);
			for (m = 1; m < nucXCoordsString.length; m++) {
				nucXCoords[m-1] = parseInt(nucXCoordsString[m]);
			}
			for (n = 1; n < nucYCoordsString.length; n++) {
				nucYCoords[n-1] = parseInt(nucYCoordsString[n]);
			}
			makeSelection("polygon", nucXCoords, nucYCoords);
			Overlay.addSelection;
		}
		for (o = 0; o < xCoords.length; o++) {
			xCoordsSum = (xCoordsSum + xCoords[o]);
			yCoordsSum = (yCoordsSum + yCoords[o]);
		}
		xCoordsAvg = (xCoordsSum/numPoints);
		yCoordsAvg = (yCoordsSum/numPoints);
		Overlay.drawString(cellNumber, xCoordsAvg, yCoordsAvg);
		cellNumber++;
	}
	Overlay.show;
}


