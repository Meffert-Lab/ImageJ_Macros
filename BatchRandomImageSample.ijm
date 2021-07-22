Dialog.create("Set Folders and Files");
Dialog.addDirectory("Cell .csv folder", "D:\\Users\\Xinbei\\");
Dialog.addDirectory("Images folder", "D:\\Users\\Xinbei\\");
Dialog.addFile("Summary statistics file", "D:\\Users\\Xinbei\\");

csvPath = Dialog.getString();
imgPath = Dialog.getString();
statFile = Dialog.getString();

randomIntegers = newArray(176, 122, 16, 76, 78, 102, 195, 77, 17, 51, 72, 132, 83, 152, 141, 127, 1, 126, 194, 184);

csvFolderContents = getFileList(csvPath);
for(i = 0; i < csvFolderContents.length; i++) {
	if (csvFolderContents[i].indexOf(".csv") == -1) {
		Array.deleteIndex(csvFolderContents, i);
	}
}
imgFolderContents = getFileList(imgPath);
for(i = 0; i < imgFolderContents.length; i++) {
	if (imgFolderContents[i].indexOf(".csv") == -1) {
		Array.deleteIndex(imgFolderContents, i);
	}
}

for(i = 0; i < randomIntegers.length; i++) {
	csvFileContents = File.openAsRawString(csvFolderContents[randomIntegers[i]]);
	csvFileArray = split(csvFileContents, "\n");
	maxMean = 0;
	zStack = -1;
	for (j = 1; j < csvFileArray.length; j++) {
		csvLine = split(csvFileArray[j], "\t");
		if (maxMean < parseFloat(csvLine[1])) {
			maxMean = parseFloat(csvLine[1]);
			zStack = j; //z-stack starts at 1 and ends at max stack
		}
	}
	open(imgPath + csvFolderContents[i].substring(0, csvFolderContents[i].lastIndexOf("_CELL")) + ".tif", zStack);
}


