Dialog.create("Set Outline File");
Dialog.addFile("Browse", "/Documents");
Dialog.addSlider("Threshold", 0, 50, 0);
Dialog.addSlider("Grid Size", 0, 32, 16);
Dialog.addCheckbox("Nuclear Exclusion", true);
Dialog.show();
thePath = Dialog.getString();
threshold = Dialog.getNumber();
gridSize = Dialog.getNumber();
nucExclude = Dialog.getCheckbox();

setBatchMode(true);

entireFile = File.openAsString(thePath);
entireFileArray = split(entireFile,"\n");

imageDirectory = "NONE_GIVEN";
imageName = "NONE_GIVEN";
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
if (imageDirectory != "NONE_GIVEN" && imageName != "NONE_GIVEN") {
	open(imageDirectory + "/" + imageName);
}
else {
	imageName = getTitle();
	
	imageDirectory = thePath.substring(0, thePath.lastIndexOf("/"));
}
cellNumber = 0;
resultNumber = 0;
for (i = 0; i < entireFileArray.length; i++) {
	if (entireFileArray[i].indexOf("CELL_START") == -1) {
   		continue;
	}
	cellNumber++;
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
	minimumX = xCoords[0];
	maximumX = xCoords[0];
	minimumY = yCoords[0];
	maximumY = yCoords[0];
	for (l = 1; l < xCoords.length; l++) {
		if (xCoords[l] < minimumX) {
			minimumX = xCoords[l];
		}
		if (xCoords[l] > maximumX) {
			maximumX = xCoords[l];
		}
	}
	for (m = 1; m < yCoords.length; m++) {
		if (yCoords[m] < minimumY) {
			minimumY = yCoords[m];
		}
		if (yCoords[m] > maximumY) {
			maximumY = yCoords[m];
		}
	}

	imageMinX = 0;
	imageMaxX = getWidth();
	imageMinY = 0;
	imageMaxY = getHeight();
	
	imageGridX = newArray((imageMaxX - imageMinX) / gridSize);
	imageGridY = newArray((imageMaxY - imageMinY) / gridSize);
	
	for (n = 0; n < imageGridX.length; n++) {
		imageGridX[n] = imageMinX + (gridSize / 2) + (n * gridSize);
	}
	for (o = 0; o < imageGridY.length; o++) {
		imageGridY[o] = imageMinY + (o * gridSize);
	}

	subRegionX = newArray(imageGridX.length);
	Array.fill(subRegionX, -1);
	subRegionY = newArray(imageGridY.length);
	Array.fill(subRegionY, -1);

	currentPointX = 0;
	for (p = 0; p < subRegionX.length; p++) {
		if (imageGridX[p] < minimumX) {
			continue;
		}
		else if (imageGridX[p] > maximumX) {
			break;
		}
		else {
			subRegionX[currentPointX] = imageGridX[p];
			currentPointX++;
		}
	}
	currentPointY = 0;
	for (q = 0; q < subRegionY.length; q++) {
		if (imageGridY[q] < minimumY) {
			continue;
		}
		else if (imageGridY[q] > maximumY) {
			break;
		}
		else {
			subRegionY[currentPointY] = imageGridY[q];
			currentPointY++;
		}
	}
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
	}
	else if (nucExclude) {
		print("NO NUCLEAR OUTLINE FOR CELL: " + cellNumber);
		doNucleus = false;
	}
	onlyInCellX = newArray;
	onlyInCellY = newArray;

	INF = Math.max(imageMaxX, imageMaxY) + 3;
	r = 0;
	t = 0;
	while (r < subRegionX.length) {
		if (subRegionX[r] == -1) {
			break;
		}
		while (t < subRegionY.length) {
			if (subRegionY[t] == -1) {
				break;
			}
			if (isInside(xCoords, yCoords, subRegionX[r], subRegionY[t])) {
				onlyInCellX[onlyInCellX.length] = subRegionX[r];
				onlyInCellY[onlyInCellY.length] = subRegionY[t];
			}
			t++;
			if (t >= subRegionY.length) {
				break;
			}
		}
		t = 0;
		r++;
		if (r >= subRegionX.length) {
			break;
		}
	}
	if (doNucleus) {
		v = 0;
		while (v < onlyInCellX.length) {
			if(isInside(nucXCoords, nucYCoords, onlyInCellX[v], onlyInCellY[v])) {
				onlyInCellX = Array.deleteIndex(onlyInCellX, v);
				onlyInCellY = Array.deleteIndex(onlyInCellY, v);
				continue;
			}
			v++;
			if (v >= onlyInCellX.length) {
				break;
			}
		}
	}
	//Array.print(onlyInCellX);
	//Array.print(onlyInCellY);
	//makeSelection("polygon", xCoords, yCoords);
	//Overlay.addSelection("red");
	//if (nucExclude) {
		//makeSelection("polygon", nucXCoords, nucYCoords);
		//Overlay.addSelection("green");
	//}
	makeSelection("polygon", xCoords, yCoords);
	roiManager("add");
	roiManager("deselect");
	roiManager("delete");
	if (File.exists(imageDirectory + "/" + imageName.substring(0, imageName.lastIndexOf(".")) + "_NUC_EXCLUDE_" + nucExclude + "_CELL-" + cellNumber + ".csv")) {
		File.delete(imageDirectory + "/" + imageName.substring(0, imageName.lastIndexOf(".")) + "_NUC_EXCLUDE_" + nucExclude + "_CELL-" + cellNumber + ".csv");
	}
	cellResultsFile = File.open(imageDirectory + "/" + imageName.substring(0, imageName.lastIndexOf(".")) + "_NUC_EXCLUDE_" + nucExclude + "_CELL-" + cellNumber + ".csv");
	print(cellResultsFile, "AREA,MEAN,MIN,MAX,SUM\n");
	for (s = 0; s < onlyInCellX.length; s++) {
		makeRectangle(onlyInCellX[s] - (gridSize / 2), onlyInCellY[s] - (gridSize / 2), gridSize, gridSize);
		roiManager("add");
		//Overlay.drawRect(onlyInCellX[s] - (gridSize / 2), onlyInCellY[s] - (gridSize / 2), gridSize, gridSize);
		roiManager("multi-measure one");
		print(cellResultsFile, "SQUARE_START" + "," + s);
		for (u = 0; u < nResults; u++) {
			areaValue = getResult("Area1", u);
			resultValue = getResult("Mean1", u);
			if (resultValue <= threshold) {
				continue;
			}
			minValue = getResult("Min1", u);
			maxValue = getResult("Max1", u);
			sumValue = areaValue * resultValue;
			print(cellResultsFile, areaValue + "," + resultValue + "," + minValue + "," + maxValue + "," + sumValue + "\n");
		}
		print(cellResultsFile, "SQUARE_END");
		roiManager("deselect");
		roiManager("delete");
	}
	File.close(cellResultsFile);
}


//Test whether a colinear point lies within a segment
//Thank you so much to GeeksforGeeks for this solution!
//https://www.geeksforgeeks.org/how-to-check-if-a-given-point-lies-inside-a-polygon/
function onSegment(testedPointX, testedPointY, segmentX1, segmentY1, segmentX2, segmentY2) {
	if (segmentX1 <= Math.max(testedPointX, segmentX2) &&
		segmentX1 >= Math.min(testedPointX, segmentX2) &&
		segmentY1 <= Math.max(testedPointY, segmentY2) &&
		segmentY1 >= Math.min(testedPointY, segmentY2)) {
			return true;
		}
	return false;
}

function orientation (pointX1, pointY1, pointX2, pointY2, pointX3, pointY3) {
	value = (pointY2 - pointY1) * (pointX3 - pointX2) - (pointX2 - pointX1) * (pointY3 - pointY2);
	if (value == 0) {
		return 0;
	}
	if (value > 0) {
		return 1;
	}
	return 2;
}

function doIntersect (point1X, point1Y, point2X, point2Y, point3X, point3Y, point4X, point4Y) {
	o1 = orientation(point1X, point1Y, point2X, point2Y, point3X, point3Y);
	o2 = orientation(point1X, point1Y, point2X, point2Y, point4X, point4Y);
	o3 = orientation(point3X, point3Y, point4X, point4Y, point1X, point1Y);
	o4 = orientation(point3X, point3Y, point4X, point4Y, point2X, point2Y);

	if (o1 != o2 && o3 != o4) {
		return true;
	}
	if (o1 == 0 && onSegment(point1X, point1Y, point3X, point3Y, point2X, point2Y)) {
		return true;
	}
	if (o2 == 0 && onSegment(point1X, point1Y, point4X, point4Y, point2X, point2Y)) {
		return true;
	}
	if (o3 == 0 && onSegment(point3X, point3Y, point1X, point1Y, point4X, point4Y)) {
		return true;
	}
	if (o4 == 0 && onSegment(point3X, point3Y, point2X, point2Y, point4X, point4Y)) {
		return true;
	}
	return false;
}

function isInside(xCoordinates, yCoordinates, pointX, pointY) {
	n = xCoordinates.length;
	numIntersections = 0;
	s = 0;
	do {
		next = (s + 1) % n;
		if (doIntersect(xCoordinates[s], yCoordinates[s], xCoordinates[next], yCoordinates[next], pointX, pointY, INF, pointY)) {
			if (orientation(xCoordinates[s], yCoordinates[s], pointX, pointY, xCoordinates[next], yCoordinates[next]) == 0) {
				return onSegment(xCoordinates[s], yCoordinates[s], pointX, pointY, xCoordinates[next], yCoordinates[next]);
			}
			if (pointY == yCoordinates[s]) {
				if (yCoordinates[next] > pointY) {
					numIntersections--;
				}
			}
			if (pointY == yCoordinates[next]) {
				if (yCoordinates[s] > pointY) {
					numIntersections--;
				}
			}
			numIntersections++;
		}
		s = next;
	} while (s != 0);
	return (numIntersections % 2 == 1);
}