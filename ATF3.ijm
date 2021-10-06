Dialog.create("Set Outline Directory");
Dialog.addDirectory("Outlines Folder", "D:\\Users\\Sreenivas\\");
Dialog.addDirectory("Images Folder", "D:\\Users\\Sreenivas\\");

Dialog.show();
outlinePath = Dialog.getString();
imgPath = Dialog.getString();

outlineDirectoryContents = getFileList(outlinePath);
File.makeDirectory(outlinePath + "/" + "INJURED");
File.makeDirectory(outlinePath + "/" + "UNINJURED");

for (i = 0; i < outlineDirectoryContents.length; i++) {
	if (outlineDirectoryContents[i].indexOf("__outline.txt") == -1) {
		continue;
	}
	entireFile = File.openAsString(outlinePath + "/" + outlineDirectoryContents[i]);
	entireFileArray = split(entireFile,"\n");

	for (j = 0; j < entireFileArray.length; j++) {
		if (entireFileArray[j].indexOf("IMG_Raw") == -1) {
			continue;
		}
		imageNameRow = split(entireFileArray[j], "\t");
		imageName = imageNameRow[1];
	}
	open(imgPath + "/" + imageName);
	run("Z Project...", "projection=[Max Intensity]");
	numCells = 0;
	cellLineNums = newArray();
	Dialog.create("ATF3?");
	for (k = 0; k < entireFileArray.length; k++) {
		if (entireFileArray[k].indexOf("CELL_START") == -1) {
   		continue;
		}
		cellLineNums[numCells] = k;
		cellNumberLine = entireFileArray[k];
		cellNumberLineArray = split(cellNumberLine, "\t");
		CellName = cellNumberLineArray[1];
		cellNumber = CellName.substring(CellName.lastIndexOf("_") + 1, CellName.length);
		//print(cellNumber);
		lineX = entireFileArray[k + 1];
		xCoordsString = split(lineX, "\t");
		xCoords = newArray(xCoordsString.length - 1);
		lineY = entireFileArray[k + 2];
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
		//Array.print(xCoords);
		for (l = 1; l < yCoordsString.length; l++) {
			yCoords[l-1] = parseInt(yCoordsString[l]);
		}
		//Array.print(yCoords);
		makeSelection("polygon", xCoords, yCoords);
		Overlay.addSelection("green");
		if (entireFileArray[k + 5].indexOf("Nucleus_START") != -1) {
			lineNucX = entireFileArray[k + 6];
			nucXCoordsString = split(lineNucX, "\t");
			nucXCoords = newArray(nucXCoordsString.length - 1);
			lineNucY = entireFileArray[k + 7];
			nucYCoordsString = split(lineNucY, "\t");
			nucYCoords = newArray(nucYCoordsString.length - 1);
			for (m = 1; m < nucXCoordsString.length; m++) {
				nucXCoords[m-1] = parseInt(nucXCoordsString[m]);
			}
			for (n = 1; n < nucYCoordsString.length; n++) {
				nucYCoords[n-1] = parseInt(nucYCoordsString[n]);
			}
			makeSelection("polygon", nucXCoords, nucYCoords);
			Overlay.addSelection("green");
		}
		for (l = 0; l < xCoords.length; l++) {
			xCoordsSum = (xCoordsSum + xCoords[l]);
			yCoordsSum = (yCoordsSum + yCoords[l]);
		}
		xCoordsAvg = (xCoordsSum/numPoints);
		yCoordsAvg = (yCoordsSum/numPoints);
		setColor("green");
		Overlay.drawString(cellNumber, xCoordsAvg, yCoordsAvg);
		numCells++;
		Dialog.addCheckbox("ATF3+? CELL_" + cellNumber, false);
	}
	Overlay.show();
	Dialog.show();
	cellStates = newArray(numCells);
	hasNegativeCells = false;
	hasPositiveCells = false;
	for (a = 0; a < numCells; a++) {
		cellStates[a] = Dialog.getCheckbox();
		if (cellStates[a] == false) {
			hasNegativeCells = true;
		}
		else {
			hasPositiveCells = true;
		}
	}
	Array.print(cellStates);
	if (hasPositiveCells == false) {
		fileToSave = File.open(outlinePath + "/" + "UNINJURED" + "/" + outlineDirectoryContents[i]);
		print(fileToSave, entireFile);
		File.close(fileToSave);
	}
	else if (hasNegativeCells == false) {
		fileToSave = File.open(outlinePath + "/" + "INJURED" + "/" + outlineDirectoryContents[i]);
		print(fileToSave, entireFile);
		File.close(fileToSave);
	}
	else {
		fileToSave1 = File.open(outlinePath + "/" + "UNINJURED" + "/" + outlineDirectoryContents[i]);
		for (b = 0; b < cellLineNums[0]; b++) {
			print(fileToSave1, entireFileArray[b]);
		}
		for (b = 0; b < numCells; b++) {
			if (cellStates[b] == false && b != numCells - 1) {
				for (c = cellLineNums[b]; c < cellLineNums[b+1]; c++) {
					print(fileToSave1, entireFileArray[c]);
				}
			}
			if (cellStates[b] == false && b == numCells - 1) {
				for (c = cellLineNums[b]; c < entireFileArray.length; c++) {
					print(fileToSave1, entireFileArray[c]);
				}
			}
		}
		File.close(fileToSave1);
		
		fileToSave2 = File.open(outlinePath + "/" + "INJURED" + "/" + outlineDirectoryContents[i]);
		for (b = 0; b < cellLineNums[0]; b++) {
			print(fileToSave2, entireFileArray[b]);
		}
		for (b = 0; b < numCells; b++) {
			if (cellStates[b] == true && b != numCells - 1) {
				for (c = cellLineNums[b]; c < cellLineNums[b+1]; c++) {
					print(fileToSave2, entireFileArray[c]);
				}
			}
			if (cellStates[b] == true && b == numCells - 1) {
				for (c = cellLineNums[b]; c < entireFileArray.length; c++) {
					print(fileToSave1, entireFileArray[c]);
				}
			}
		}
		File.close(fileToSave2);
	}
	close("*");
}
print("DONE");
