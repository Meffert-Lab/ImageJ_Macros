Dialog.create("Set Outline File");
Dialog.addDirectory("Outlines", "/Documents");
Dialog.addDirectory("Images", "/Documents");
//Dialog.addSlider("Threshold", 0, 50, 0);
//Dialog.addSlider("Grid Size", 0, 32, 16);
Dialog.addCheckbox("Nuclear Exclusion", true);
Dialog.show();
thePath = Dialog.getString();
imageDirectory = Dialog.getString();
//threshold = Dialog.getNumber();
//gridSize = Dialog.getNumber();
nucExclude = Dialog.getCheckbox();

setBatchMode(true);

directoryContents = getFileList(thePath);

for (a = 0; a < directoryContents.length; a++) {
	if (directoryContents[a].indexOf("__outline.txt") == -1) {
		continue;
	}
	entireFile = File.openAsString(thePath + directoryContents[a]);
	entireFileArray = split(entireFile,"\n");
	imageName = "NONE_GIVEN";
	/*for (i = 0; i < entireFileArray.length; i++) {
		if (entireFileArray[i].indexOf("IMG_DIR") == -1) {
			continue;
		}
		imageDirectoryRow = split(entireFileArray[i], "\t");
		imageDirectory = imageDirectoryRow[1];
	}*/
	for (i = 0; i < entireFileArray.length; i++) {
		if (entireFileArray[i].indexOf("IMG_Raw") == -1) {
			continue;
		}
		imageNameRow = split(entireFileArray[i], "\t");
		imageName = imageNameRow[1];
	}
	open(imageDirectory + "/" + imageName);
	cellNumber = 1;
	resultNumber = 0;
	for (i = 0; i < entireFileArray.length; i++) {
		if (entireFileArray[i].indexOf("CELL_START") == -1) {
   			continue;
		}
		lineX = entireFileArray[i + 1];
		xCoordsString = split(lineX, "\t");
		xCoords = newArray(xCoordsString.length - 1);
		lineY = entireFileArray[i + 2];
		yCoordsString = split(lineY, "\t");
		yCoords = newArray(yCoordsString.length - 1);
		xCoordsAvg = 0;
		yCoordsAvg = 0;
		numPoints = 0;
		xCoordsSum = 0;
		yCoordsSum = 0;
		Array.fill(xCoords, -2);
		Array.fill(yCoords, -2);
		for (j = 1; j < xCoordsString.length; j++) {
			xCoords[j-1] = parseInt(xCoordsString[j]);
			numPoints++;
		}
		for (k = 1; k < yCoordsString.length; k++) {
			yCoords[k-1] = parseInt(yCoordsString[k]);
		}
		makeSelection("polygon", xCoords, yCoords);
		roiManager("add");
		if (RoiManager.size > 1) {
			roiManager("deselect");
			roiManager("delete");
			makeSelection("polygon", xCoords, yCoords);
			roiManager("add");
		}
		//makeSelection("polygon", xCoords, yCoords);
		//Overlay.addSelection("green");
		if (entireFileArray[i + 5].indexOf("Nucleus_START") != -1 && nucExclude) {
			lineNucX = entireFileArray[i + 6];
			nucXCoordsString = split(lineNucX, "\t");
			nucXCoords = newArray(nucXCoordsString.length - 1);
			lineNucY = entireFileArray[i + 7];
			nucYCoordsString = split(lineNucY, "\t");
			nucYCoords = newArray(nucYCoordsString.length - 1);
			for (m = 1; m < nucXCoordsString.length; m++) {
				nucXCoords[m-1] = parseInt(nucXCoordsString[m]);
			}
			for (n = 1; n < nucYCoordsString.length; n++) {
				nucYCoords[n-1] = parseInt(nucYCoordsString[n]);
			}
			doNucleus = true;
			makeSelection("polygon", nucXCoords, nucYCoords);
			roiManager("add");
			roiManager("deselect");
			roiManager("XOR");
			roiManager("delete");
			roiManager("add");
			//makeSelection("polygon", nucXCoords, nucYCoords);
			//Overlay.addSelection("green");
		}
		else if (nucExclude) {
			print("NO NUCLEAR OUTLINE FOR CELL: " + cellNumber + " FILE: " + directoryContents[a]);
			doNucleus = false;
		}
	for (l = 0; l < xCoords.length; l++) {
		xCoordsSum = (xCoordsSum + xCoords[l]);
		yCoordsSum = (yCoordsSum + yCoords[l]);
	}
	xCoordsAvg = (xCoordsSum/numPoints);
	yCoordsAvg = (yCoordsSum/numPoints);
	//setColor("green");
	//Overlay.drawString(cellNumber, xCoordsAvg, yCoordsAvg);
	if (File.exists(thePath + "/" + imageName.substring(0, imageName.lastIndexOf(".")) + "_CELL-" + cellNumber + ".csv")) {
		File.delete(thePath + "/" + imageName.substring(0, imageName.lastIndexOf(".")) + "_CELL-" + cellNumber + ".csv");
	}
	cellResultsFile = File.open(thePath + "/" + imageName.substring(0, imageName.lastIndexOf(".")) + "_CELL-" + cellNumber + ".csv");
	print(cellResultsFile, "AREA,MEAN,MIN,MAX,SUM\n");
	roiManager("multi-measure one");
	for (u = 0; u < nResults; u++) {
		cytoArea = getResult("Area1", u);
		resultValue = getResult("Mean1", u);
		minValue = getResult("Min1", u);
		maxValue = getResult("Max1", u);
		sumValue = cytoArea * resultValue;
		print(cellResultsFile, cytoArea + "," + resultValue + "," + minValue + "," + maxValue + "," + sumValue + "\n");
	}
	File.close(cellResultsFile);
	roiManager("deselect");
	roiManager("delete");
	cellNumber++;
}
//Overlay.show;
close("*");
}
print("BATCH COMPLETE");