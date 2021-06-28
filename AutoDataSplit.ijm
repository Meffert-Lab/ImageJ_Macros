Dialog.create("Choose Working Directory");
Dialog.addDirectory("Browse", "D:\\Users\\Xinbei\\");
Dialog.show();
thePath = Dialog.getString();

masterDirectory = getFileList(thePath);
listOfDirectories = newArray(masterDirectory);
searchForSubdirectories (masterDirectory, listOfDirectories);

for (i = 0; i < listOfDirectories.length(); i++) {
	splitData (listOfDirectories[i]);
}

function searchForSubdirectories (directoryToSearch, listOfDirectories) {
	contentsOfDirectory = getFileList(directoryToSearch);
	for (i = 0; i < contentsOfDirectory.length(); i++) {
		if (File.isDirectory(contentsOfDirectory[i])) {
			listOfDirectories[listOfDirectories.length] = contentsOfDirectory[i];
			searchForSubdirectories (contentsOfDirectory[i], listOfDirectories);
		}
	}
}

function splitData (directoryContents) {
	for (i = 0; i < directoryContents.length(); i++) {
		if(!File.isFile(directoryContents[i])) {
			continue;
		}
		filenameWithoutExtension = "";
		for(j = 0; j < directoryContents[i].length(); j++) {
			if (directoryContents[i].charAt(j) == '.') {
				break;
			}
			filenameWithoutExtension.append(directoryContents[i].charAt(j));
		}
		run("Bio-Formats", "open=[" + thePath + directoryContents[i] + "] autoscale color_mode=default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_");
		getDimensions(width, height, channels, slices, frames);
		run("Duplicate...", "duplicate frames=1");
		run(run("Arrange Channels...", "new=2356");
		run("Split Channels");
		for (k = 1; k <= channels; k++) {
			channelNumber = channels - k;
			run("Save", "save=[" + thePath + directoryContents[i] + "_C" + channelNumber + "-1.tif]");
			close();
		}
		close("*");
	}
}