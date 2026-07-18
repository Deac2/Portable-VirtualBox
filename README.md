<img width="658" height="378" alt="image" src="https://github.com/user-attachments/assets/6753a769-75d0-4c09-a864-f2f8fde3e23f"/><br>
<img width="576" height="378" alt="image" src="https://github.com/user-attachments/assets/842e4e72-5b98-4c27-b5a4-e3d0afed0acd"/><br>
This version with a new settings window, delete the folder data\language if you copy to the old folder with virtualbox the language has differences and most of the unnecessary is removed.<br>
<a href="https://github.com/Deac2/Portable-VirtualBox_NewMenuTest" target="_blank">Portable-VirtualBox Testing</a><br>
<a href="https://github.com/Deac2/Portable-VirtualBox_old_menu-Settings" target="_blank">Old version of Virtualbox settings</a><br>
If something doesn't work, open issues in the thread you downloaded from (it's better to create in my repositories).<br>
The download and installation window has been redesigned<br>
data\settings\settings.ini<br>
[lang]<br>
key=2 Writes the currently selected language to the ini file. If needed, use the number 2.<br>
key=1 The language is taken directly from the array; language files are not created.<br>

22.10.2024 If you have an old language folder, Delete the data\language folder as the languages ​​have been partially changed.<br>
Disable message center notifications and screen capture messages VirtualBoxVM.exe default settings directory:<br>
Portable-VirtualBox\\.VirtualBox\VirtualBox.xml<br>
Change or add before launch <ExtraDataItem name=\"GUI/SuppressMessages\" value=\"all\"/> sample:<br><br>
<ExtraData\><br>
<ExtraDataItem name=\"GUI/GuestControl/FileManagerVisiblePanel\" value=\"LogPanel\"/><br>
<ExtraDataItem name=\"GUI/LastItemSelected\" value=\"m=2bd3571f-97f7-4297-b779-2b6f3d9c5ae0\"/><br>
<ExtraDataItem name=\"GUI/LastWindowPosition\" value=\"121,139,848,438\"/><br>
<ExtraDataItem name=\"GUI/SessionInformationDialogGeometry\" value=\"296,140,512,360\"/><br>
<ExtraDataItem name=\"GUI/SuppressMessages\" value=\"all\"/><br>
<ExtraDataItem name=\"GUI/Tools/LastItemsSelected\" value=\"Welcome,Details\"/><br>
<\/ExtraData><br><br>
Save the VirtualBox.xml file

Portable-VirtualBox Change bug
===================

Portable-VirtualBox is a free and open source software tool that lets you run any operating system from a USB stick without separate installation.

### Building ###

Run Build_x64.bat or Build_x86.bat.<br>
Running the AutoIt_RunTrayDebug.bat executable file without compiling it (for experienced users, there may be garbage in the Source folder)<br>
