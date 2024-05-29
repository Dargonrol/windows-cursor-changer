# windows-curser-changer
This is a small script which allows you to easily change the cursor appearance. It will prompt you to provide a path to a folder where you can place .cur as well as .ani files. The script should automatically detect which file corresponds to which cursor as long as the filename includes certain keywords like 'arrow', 'working', or 'busy'. It automatically creates a scheme for you and applies it. With this script, you can **create**, **list**, and **delete** schemes.

## How to use
1. open powershell as an administrator
2. you may need to enable scripts: `Set-ExecutionPolicy Unrestricted -Force`
3. direct to the directory of the script with `cd PATH`
4. run the script simply by typing it's name into the console.
