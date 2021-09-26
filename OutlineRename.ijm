Dialog.create("Set Outline Directory");
Dialog.addDirectory("Outlines", "/Documents");
Dialog.addSlider("Channel Number", 0, 8, 2);

Dialog.show();

thePath = Dialog.getString();
channelNum = Dialog.getNumber();

directoryContents = getFileList(thePath);
File.makeDirectory(thePath + "_RENAME_CH_" + channelNum);

for (a = 0; a < directoryContents.length; a++) {
	if (directoryContents[a].indexOf("__outline.txt") == -1) {
		continue;
	}
	entireFile = File.openAsString(thePath + directoryContents[a]);
	entireFileArray = split(entireFile,"\n");

	for (i = 0; i < entireFileArray.length; i++) {
		if (entireFileArray[i].indexOf("IMG_Raw") == -1) {
			continue;
		}
		imageNameRow = split(entireFileArray[i], "\t");
		imageName = imageNameRow[1];
		rowToChange = i;
	}

	newImageName = imageName.substring(0, imageName.lastIndexOf("_C")) + "_C" + channelNum + imageName.substring(imageName.lastIndexOf("_C") + 3, imageName.length);
	newFileName = newImageName.substring(0, newImageName.lastIndexOf(".tif")) + "__outline.txt";

	currentFile = File.open(thePath + "_RENAME_CH_" + channelNum + "/" + newFileName);
	for (j = 0; j < rowToChange; j++) {
		print(currentFile, entireFileArray[j]);
	}
	print(currentFile, imageNameRow[0] + "\t" + newImageName);
	for (k = j + 1; k < entireFileArray.length; k++) {
		print(currentFile, entireFileArray[k]);
	}
	File.close(currentFile);
}
print("DONE");