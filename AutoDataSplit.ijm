setBatchMode(true);
Dialog.create("Choose Working Directory");
Dialog.addDirectory("Browse", "D:\\Users\\Xinbei\\");
Dialog.show();
thePath = Dialog.getString();
listOfDirectories = newArray;
listOfDirectories[0] = thePath;
listOfDirectories = searchForSubdirectories(thePath, listOfDirectories);
for (i = 0; i < listOfDirectories.length; i++) {
	directoryContents = getFileList(listOfDirectories[i]);
	splitData (directoryContents, listOfDirectories[i]);
}
function searchForSubdirectories (directoryToSearch, listOfDirectories) {
	contentsOfDirectory = getFileList(directoryToSearch);
	for (i = 0; i < contentsOfDirectory.length; i++) {
		if (File.isDirectory(directoryToSearch + contentsOfDirectory[i])) {
			listOfDirectories[listOfDirectories.length] = directoryToSearch + contentsOfDirectory[i];
			listOfDirectories = searchForSubdirectories("" + directoryToSearch + contentsOfDirectory[i], listOfDirectories);
		}
	}
	return listOfDirectories;
}
function splitData (directoryContents, folder) {
	for (i = 0; i < directoryContents.length; i++) {
		if(File.isDirectory(folder + directoryContents[i])) {
			continue;
		}
		filenameWithoutExtension = directoryContents[i].substring(0, directoryContents[i].lastIndexOf("."));
		run("Bio-Formats", "open=[" + folder + directoryContents[i] + "] autoscale color_mode=Default rois_import=[ROI manager] split_channels split_timepoints view=Hyperstack stack_order=XYCZT");
		currentTitle = getTitle();
		partOfCurrentTitle = currentTitle.substring(currentTitle.lastIndexOf("T="), currentTitle.length);
		while (parseInt(currentTitle.substring(currentTitle.lastIndexOf("T=") + 2, currentTitle.lastIndexOf("T=") + partOfCurrentTitle.indexOf(" "))) != 0) {
			close();
			currentTitle = getTitle();
			partOfCurrentTitle = currentTitle.substring(currentTitle.lastIndexOf("T="), currentTitle.length);
		}
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