### Step 1: Locate the `whitelist.prop` File

The `whitelist.prop` file is automatically created in the root of your internal storage on the first boot of the module.

> If the file doesn't exist, ensure the module is properly installed and has been active for at least one boot cycle.

### Step 2: Edit the `whitelist.prop` File

You can edit this file using any text editor app on your Android device that can access the internal storage. Some popular options include:

*   **FX File Explorer**
*   **Solid Explorer**
*   **MT Manager**
*   **Zarchiever**
*   **Notepad** (Any text editor)

You can also use a PC by connecting your device via USB and enabling file transfer and use Notepad editor on your PC.

### Step 3: Add Package Names to the Whitelist

Each line in the `whitelist.prop` file should contain a single package name that you want to exclude. Add package names you want to whitelist, one per line. For example:
>`com.facebook.katana`
`com.facebook.orca`
`com.instagram.android`
`org.telegram.messenger`


### Step 4: Save the file

No need to reboot your device for the changes to take effect.
