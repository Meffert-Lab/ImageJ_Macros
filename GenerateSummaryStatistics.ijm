Dialog.create("Choose Working Directory");
Dialog.addDirectory("Browse", "D:\\Users\\Xinbei\\");
Dialog.show();
thePath = Dialog.getString();

directoryContents = getFileList(thePath);
summaryFile = File.open(thePath + File.separator + "SUMMARY_STATISTICS.tsv");
print(summaryFile, "FILENAME" + "\t" + "MAX_MEAN" + "\t" + "MIN_MEAN" + "\t" + "AVG_MEAN"
	+ "\t" + "MAX_MIN" + "\t" + "MIN_MIN" + "\t" + "AVG_MIN"
	+ "\t" + "MAX_MAX" + "\t" + "MIN_MAX" + "\t" + "AVG_MAX" + "\t" + "SUM_INT");
for (i = 0; i < directoryContents.length; i++) {
	if (directoryContents[i].indexOf("CELL-") == -1) {
		continue;
	}
	if (directoryContents[i].indexOf(".csv") == -1) {
		continue;
	}

	fileString = File.openAsRawString(thePath + File.separator + directoryContents[i], 9999);
	fileArray = split(fileString, "\n");
	
	sumMean = 0.0;
	sumMin = 0.0;
	sumMax = 0.0;
	numRows = 0;
	aggregateSum = 0;

	lineArrayAsString = split(fileArray[1], ",");
	area = parseFloat(lineArrayAsString[0]);
	maximumMean = parseFloat(lineArrayAsString[1]);
	minimumMean = parseFloat(lineArrayAsString[1]);
	minimumMin = parseFloat(lineArrayAsString[2]);
	maximumMin = parseFloat(lineArrayAsString[2]);
	maximumMax = parseFloat(lineArrayAsString[3]);
	minimumMax = parseFloat(lineArrayAsString[3]);

	for (j = 2; j < fileArray.length; j++) {
		lineArrayAsString = split(fileArray[j], ",");
		numRows++;
		meanVal = parseFloat(lineArrayAsString[1]);
		minVal = parseFloat(lineArrayAsString[2]);
		maxVal = parseFloat(lineArrayAsString[3]);
		sumMean+=meanVal;
		sumMin+=minVal;
		sumMax+=maxVal;
		aggregateSum+=meanVal * area;
		if (meanVal > maximumMean) {
			maximumMean = meanVal;
		}
		if (meanVal < minimumMean) {
			minimumMean = meanVal;
		}
		if (minVal > maximumMin) {
			maximumMin = minVal;
		}
		if (minVal < minimumMin) {
			minimumMin = minVal;
		}
		if (maxVal > maximumMax) {
			maximumMax = maxVal;
		}
		if (maxVal < minimumMax) {
			minimumMax = maxVal;
		}
	}
	averageMean = sumMean / numRows;
	averageMin = sumMin / numRows;
	averageMax = sumMax / numRows;
	print(summaryFile, directoryContents[i] + "\t" + maximumMean + "\t" + minimumMean + "\t" + averageMean
		+ "\t" + maximumMin + "\t" + minimumMin + "\t" + averageMin
		+ "\t" + maximumMax + "\t" + minimumMax + "\t" + averageMax + "\t" + aggregateSum);
}
print("DONE");