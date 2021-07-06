Dialog.create("Set Outline File");
Dialog.addFile("Browse", "/Documents");
Dialog.show();
thePath = Dialog.getString();

entireFile = File.openAsString(thePath);
entireFileArray = split(entireFile,"\n");
cellNumber = 1;

imageDirectory = "NONE GIVEN";
imageName = "NONE GIVEN";
for (i = 0; i < entireFileArray.length; i++) {
	if (entireFileArray[i].indexOf("IMG_DIR") == -1) {
		continue;
	}
	imageDirectoryRow = split(entireFileArray[i], "\t");
	imageDirectory = imageDirectoryRow[1];
}
for (i = 0; i < entireFileArray.length; i++) {
	if (entireFileArray[i].indexOf("IMG_Raw") == -1) {
		continue;
	}
	imageNameRow = split(entireFileArray[i], "\t");
	imageName = imageNameRow[1];
}
if (imageDirectory != "NONE GIVEN" && imageName != "NONE GIVEN") {
	open(imageDirectory + "/" + imageName);
}

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
	for (j = 1; j < xCoordsString.length; j++) {
		xCoords[j-1] = xCoordsString[j];
		numPoints++;
	}
	for (k = 1; k < yCoordsString.length; k++) {
		yCoords[k-1] = yCoordsString[k];
	}
	makeSelection("polygon", xCoords, yCoords);
	run("Measure");
	Overlay.addSelection("red");
	for (l = 0; l < xCoords.length; l++) {
		xCoordsSum = (xCoordsSum + xCoords[l]);
		yCoordsSum = (yCoordsSum + yCoords[l]);
	}
	xCoordsAvg = (xCoordsSum/numPoints);
	yCoordsAvg = (yCoordsSum/numPoints);
	setColor("red");
	Overlay.drawString(cellNumber, xCoordsAvg, yCoordsAvg);
	cellNumber++;
}
Overlay.show;