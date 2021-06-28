Dialog.create("Set Outline File");
Dialog.addFile("Browse", "/Documents");
Dialog.show();
thePath = Dialog.getString();

entireFile = File.openAsString(thePath);
entireFileArray = split(entireFile,"\n");

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

	minimumX = xCoords[0];
	maximumX = xCoords[0];
	minimumY = yCoords[0];
	maximumY = yCoords[0];
	for (i = 1; i < xCoords.length; i++) {
		if (xCoords[i] < minimumX) {
			minimumX = xCoords[i];
		}
		if (xCoords[i] > maximumX) {
			maximumX = xCoords[i];
		}
	}
	for (i = 1; i < yCoords.length; i++) {
		if (yCoords[i] < minimumY) {
			minimumY = yCoords[i];
		}
		if (yCoords[i] > maximumY) {
			maximumY = yCoords[i];
		}
	}

	imageMinX = 0;
	imageMaxX = getWidth();
	imageMinY = 0;
	imageMaxY = getHeight();

	gridSize = 6;
	
	imageGridX = newArray((imageMaxX / gridSize) - imageMinX);
	imageGridY = newArray((imageMaxY / gridSize) - imageMinY);
	
	for (i = 0; i < imageGridX.size; i++) {
		imageGridX[i] = imageMinX + (i * gridSize);
	}
	for (i = 0; i < imageGridY.size; i++) {
		imageGridY[i] = imageMinY + (i * gridSize);
	}

	subRegionX = newArray(imageGridX.size);
	Array.fill(subRegionX, -1);
	subRegionY = newArray(imageGridY.size);
	Array.fill(subRegionY, -1);

	currentPointX = 0;
	for (i = 0; i < subRegionX.size; i++) {
		if (imageGridX[i] < imageMinX) {
			continue;
		}
		else if (imageGridX[i] > imageMaxX) {
			break;
		}
		else {
			subRegionX[currentPointX] = imageGridX[i];
			currentPointX++;
		}
	}
	currentPointY = 0;
	for (i = 0; i < subRegionY.size; i++) {
		if (imageGridY[i] < imageMinY) {
			continue;
		}
		else if (imageGridY[i] > imageMaxY) {
			break;
		}
		else {
			subRegionY[currentPointY] = imageGridY[i];
			currentPointY++;
		}
	}

	onlyInCellX = newArray(currentPointX);
	onlyInCellY = newArray(currentPointY);

	INF = Math.max(imageMaxX, imageMaxY) + 3;

	while (subRegionX[i] != -1 && subRegionY[i] != -1) {
		
	}
	
}
//Test whether a colinear point lies within a segment
//Thank you so much to GeeksforGeeks for this solution!
//https://www.geeksforgeeks.org/how-to-check-if-a-given-point-lies-inside-a-polygon/
function onSegment(testedPointX, testedPointY, segmentX, segmentY, result) {
	result[0] = segmentX[0] <= Math.max(testedPointX[0], segmentX[1]) &&
				segmentX[0] >= Math.min(testedPointX[0], segmentX[1]) &&
				segmentY[0] <= Math.max(testedPointY[0], segmentY[1]) &&
				segmentY[0] >= Math.min(testedPointY[0], segmentY[1])
}


