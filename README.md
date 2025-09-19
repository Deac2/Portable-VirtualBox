<img width="576" height="378" alt="image" src="https://github.com/user-attachments/assets/842e4e72-5b98-4c27-b5a4-e3d0afed0acd"/><br>
This version with a new settings window, delete the folder data\language if you copy to the old folder with virtualbox the language has differences and most of the unnecessary is removed.<br>
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

Please see here for information on how to build from source: [BUILDING](BUILDING.md).

### Changelog for VirtualBox ###

<strong>VirtualBox 7.0.26</strong> (released April 15 2025)<br /><br />
This is a maintenance release. The following items were fixed and/or added:
</p>
<ul><li>VMM: Fixed issue when VM clock went backwards in rare circumstances (bug <a class="closed ticket" href="https://www.virtualbox.org/ticket/22334" target="_blank" title="#22334: defect: VM clock goes backwards =&gt; fixed in svn (closed: fixed)">#22334</a>)
</li><li>DevVirtioSCSI: Fixed issue with restoring saved state
</li><li>Graphics: Fixed issue when assertion was triggered on restoring VM state if VMSVGA graphics adapter was used without 3D acceleration (bug <a class="closed ticket" href="https://www.virtualbox.org/ticket/21955" target="_blank" title="#21955: defect: Heavy screen flickering VirtualBox 6.1.48 / 7.0.12 Ubuntu Wayland ... (closed: fixed)">#21955</a>)
</li><li>Main: Fixed issue when wireless network adapters could not be discovered on modern Linux distributions (bug <a class="closed ticket" href="https://www.virtualbox.org/ticket/22362" target="_blank" title="#22362: defect: Linux host: Change the wireless interface detection mechanism =&gt; fixed ... (closed: fixed)">#22362</a>)
</li><li>Main: Fixed issue when deleting running VM snapshot was leaving the .sav file on disk (bug <a class="closed ticket" href="https://www.virtualbox.org/ticket/21345" title="#21345: defect: Deleting running VM snapshot leaves the .sav file on disk (closed: fixed)">#21345</a>)
</li><li>VBoxManage: Updated User Manual to correct the 'VBoxManage modifyvm' invocation for configuring a VM to use host-only networking (bug <a class="closed ticket" href="https://www.virtualbox.org/ticket/22158" target="_blank" title="#22158: defect: VirtualBox API exports Host-Only adapter without name (closed: fixed)">#22158</a>)
</li><li>Linux Host Installer: Fixed issue which sometimes resulted in installation failure due to incorrect check whether previous <a class="wiki" href="https://www.virtualbox.org/wiki/VirtualBox" target="_blank">VirtualBox</a> installation is running or not
</li><li>Linux Guest Additions: Fixed issue which resulted in cursor image corruption when VM was using VBoxVGA graphics adapter
</li><li>Linux Guest Additions: Fixed issue when installation could fail on the system which does not have X11 libraries installed
</li><li>Linux Guest Additions: Added initial support for kernel 6.14
</li><li>Linux Guest Additions: Introduced initial support for RHEL 9.7 kernel
</li><li>Linux Guest Additions: Introduced additional fixes for RHEL 9.4 kernel, (bug <a class="closed ticket" href="https://www.virtualbox.org/ticket/22277" target="_blank" title="#22277: defect: Bad address error on Linux write syscall on RHEL 9.4 =&gt; fixed in svn (closed: fixed)">#22277</a>)
</li><li>Linux Guest Additions: Improved 'rcvboxadd status-kernel' check
</li><li>Windows installer: Various bugfixes for the new installation code
</li><li>Windows installer: Implemented a new fatal error dialog with the ability to open the installer log file directly
</li><li>Windows Guest Additions: Fixed mouse driver installation on Vista guests
</li><li>Windows Guest Additions: Fixed uninstallation integrity issues (bug <a class="closed ticket" href="https://www.virtualbox.org/ticket/22290" target="_blank" title="#22290: defect: Windows Guest Additions cannot be uninstalled (closed: fixed)">#22290</a>)
</li><li>Windows Guest Additions: Fixed driver installation error ERROR_AUTHENTICODE_TRUST_NOT_ESTABLISHED (bug <a class="closed ticket" href="https://www.virtualbox.org/ticket/22300" target="_blank" title="#22300: defect: Impossible to install guest image on windows 7 ... (closed: fixed)">#22300</a>)
</li><li>Windows Guest Additions: Fixed 100% CPU usage of VBoxTray which happened under certain circumstances (bug <a class="closed ticket" href="https://www.virtualbox.org/ticket/22123" target="_blank" title="#22123: defect: Infinite Loop in Guest Addition for Windows XP (1 Core always 100% on ... (closed: fixed)">#22123</a>)
</li><li>Windows Guest Additions: Now also ships the VBoxAudioTest binary for performing guest audio testing / diagnosis
</li><li>Windows Guest Additions: For older Windows versions (Windows 2000 to Windows 7) install alternative Shared Folder driver which avoids some compatibility glitches of the usual driver
</li></ul>
