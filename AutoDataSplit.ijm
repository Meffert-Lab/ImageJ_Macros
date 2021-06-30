Dialog.create("Choose Working Directory");
Dialog.addDirectory("Browse", "D:\\Users\\Xinbei\\");
Dialog.show();
thePath = Dialog.getString();

listOfDirectories = newArray;
listOfDirectories[0] = thePath;
listOfDirectories = searchForSubdirectories(thePath, listOfDirectories);
Array.print(listOfDirectories);
for (i = 0; i < listOfDirectories.length; i++) {
	directoryContents = getFileList(listOfDirectories[i]);
	splitData (directoryContents, listOfDirectories[i]);
}

function searchForSubdirectories (directoryToSearch, listOfDirectories) {
	contentsOfDirectory = getFileList(directoryToSearch);
	for (i = 0; i < contentsOfDirectory.length; i++) {
		if (File.isDirectory(directoryToSearch + contentsOfDirectory[i])) {
			listOfDirectories[listOfDirectories.length] = directoryToSearch + contentsOfDirectory[i];
			print(directoryToSearch + contentsOfDirectory[i] + "is a directory");
			Array.print(listOfDirectories);
			print(directoryToSearch + contentsOfDirectory[i]);
			listOfDirectories = searchForSubdirectories("" + directoryToSearch + contentsOfDirectory[i], listOfDirectories);
		}
	}
	return listOfDirectories;
}

function splitData (directoryContents, folder) {
	for (i = 0; i < directoryContents.length; i++) {
		if(File.isDirectory(folder + directoryContents[i])) {
			print(directoryContents[i] + "is a Directory and will not be split");
			continue;
		}
		filenameWithoutExtension = "";
		for(j = 0; j < directoryContents[i].length; j++) {
			if (directoryContents[i].charAt(j) == '.') {
				break;
			}
			filenameWithoutExtension += directoryContents[i].charAt(j);
		}
		print(filenameWithoutExtension);
		run("Bio-Formats", "open=[" + folder + directoryContents[i] + "] autoscale color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT series_");
		//getDimensions(width, height, channels, slices, frames);
		//run("Duplicate...", "duplicate frames=1");
		//run("Arrange Channels...", "new=123456");
		//run("Split Channels");
		channels = nImages;
		for (k = 1; k <= channels; k++) {
			channelNumber = channels - k + 1;
			run("Save", "save=[" + folder + filenameWithoutExtension + "_C" + channelNumber + "-1.tif]");
			close();
		}
		close("*");
		run("Collect Garbage");
	}
}