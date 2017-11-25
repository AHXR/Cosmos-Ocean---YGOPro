/*
	@title
		Cosmos Ocean Installer
	@author
		AHXR (https://github.com/AHXR)
	@copyright
		2017

	Cosmos Ocean Installer is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	Cosmos Ocean Installer is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with Cosmos Ocean Installer.  If not, see <http://www.gnu.org/licenses/>.
*/
//=======================================================
#include				<iostream>
#include				<string>
#include				<Windows.h>
#include				<fstream>
#include				<sys/stat.h>

#include				"resource.h"
#include				"ahxrlogger.h"

using namespace         std;

#define					EXTRACT_FILE				"CosmosOceanCDB.zip"
#define					EXTRACTER_FILE				"7za.exe"
#define					EXTRACT_FOLDER				"expansions\\CosmosOceanInstaller\\"
#define					FILE_CHECK					"ygopro_vs.exe"
#define					FILE_CHECK_LINKS			"ygopro_vs_links.exe"
#define					PAUSE_TIME					2000
#define					READ						Sleep(PAUSE_TIME)

void					cleanExit(const char * path);
void					extractCardData(char * dir);
void					cleanDirectory(char * token = "");
void					writeResource(char * fileName, string path, int resourceID);

void main() {
	LOG("Cosmos Ocean Installer Started. One moment...");

	struct stat	
		file_check_buff
	;

	if (stat(FILE_CHECK, & file_check_buff) != 0 && stat(FILE_CHECK_LINKS, &file_check_buff) != 0 ) {
		ERROR("Please assure that you have placed this file in your YGOPro directory."); 
		cleanExit(EXTRACT_FOLDER);
	}

	cleanDirectory();
	CreateDirectory(EXTRACT_FOLDER, NULL);

	LOG("[COLOR:GREEN]Extracting to '%s'", EXTRACT_FOLDER);
	LOG("Unloading required installation files...\r\n");

	// Unloading CosmosOceanCDB.zip
	writeResource(EXTRACT_FILE, EXTRACT_FOLDER, IDR_RCDATA1 );

	// Unloading 7za.exe
	writeResource(EXTRACTER_FILE, EXTRACT_FOLDER, IDR_RCDATA2 );

	// 7zip extraction
	LOG("\r\nDecompressing Cosmos Ocean cards...");

	char 
		c_buffer[ 100 ]
	;
	sprintf(c_buffer, "%s%s x %s%s -o%s -y", EXTRACT_FOLDER, EXTRACTER_FILE, EXTRACT_FOLDER, EXTRACT_FILE, EXTRACT_FOLDER);
	system(c_buffer);

	LOG("\r\nDecompressing completed. Adding card images...[COLOR:GREEN]"); READ;

	// Extracting Pictures
	extractCardData("pics");
	extractCardData("pics\\thumbnail");
	LOG("\r\nPicture Extraction completed. Adding scripts...[COLOR:GREEN]"); READ;

	// Extracting Scripts
	extractCardData("script");
	LOG("\r\nScript Extraction completed. Adding decks...[COLOR:GREEN]"); READ;

	// Extracting Decks
	extractCardData("deck");
	LOG("\r\nDeck Extraction completed.[COLOR:GREEN]\r\n"); READ;
	LOG("\r\nFinally extracting CosmosOcean.cdb [COLOR:GREEN]\r\n"); READ;

	// Extracting db
	TCHAR			
		c_old_path[MAX_PATH]
	;
	sprintf(c_old_path, "%sCosmosOcean.cdb", EXTRACT_FOLDER);
	MoveFileEx(c_old_path, "expansions\\CosmosOcean.cdb", MOVEFILE_REPLACE_EXISTING);

	// Cleaning up
	LOG("Database extraction completed. Cleaning up...[COLOR:GREEN]");
	cleanDirectory(); RemoveDirectory(EXTRACT_FOLDER); READ;

	LOG("\r\nDone. Enjoy! https:\\github.com\\AHXR");
	system("pause");
}

void extractCardData(char * dir) {

	char
		c_buffer[MAX_PATH]
	;

	WIN32_FIND_DATA				w32_search;
	HANDLE						h_search;
	TCHAR						c_old_path[MAX_PATH];
	TCHAR						c_new_path[MAX_PATH];

	sprintf(c_buffer, "%s%s\\*", EXTRACT_FOLDER, dir);
	h_search = FindFirstFile(c_buffer, &w32_search);

	if (h_search) {
		do {
			if (w32_search.dwFileAttributes != FILE_ATTRIBUTE_DIRECTORY) {
				sprintf(c_old_path, "%s%s\\%s", EXTRACT_FOLDER, dir, w32_search.cFileName);
				sprintf(c_new_path, "%s\\%s", dir, w32_search.cFileName);
				MoveFileEx(c_old_path, c_new_path, MOVEFILE_REPLACE_EXISTING);

				LOG("[%s] moved to script folder. (%s)", w32_search.cFileName, c_new_path);
			}

		} while (FindNextFile(h_search, &w32_search));
	}
	FindClose( h_search );
}

void cleanDirectory( char * token ) {
	char
		c_buffer[MAX_PATH]
	;

	WIN32_FIND_DATA				w32_search;
	HANDLE						h_search;
	TCHAR						c_old_path[MAX_PATH];

	if( strlen(token) <= 0 ) 
		sprintf(c_buffer, "%s*", EXTRACT_FOLDER );
	else
		sprintf(c_buffer, "%s%s\\*", EXTRACT_FOLDER, token);

	h_search = FindFirstFile(c_buffer, &w32_search);

	if (h_search) {
		do {
			if (strlen(token) <= 0)
				sprintf(c_old_path, "%s%s", EXTRACT_FOLDER, w32_search.cFileName);
			else
				sprintf(c_old_path, "%s%s\\%s", EXTRACT_FOLDER, token, w32_search.cFileName);

			if (w32_search.dwFileAttributes != FILE_ATTRIBUTE_DIRECTORY)
				remove(c_old_path);
		
			else if (w32_search.dwFileAttributes == FILE_ATTRIBUTE_DIRECTORY && strcmp(w32_search.cFileName, ".") != 0 && strcmp(w32_search.cFileName, "..") != 0) {
				cleanDirectory(w32_search.cFileName);
				RemoveDirectory(c_old_path);
			}
				

		} while (FindNextFile(h_search, &w32_search));
	}
	FindClose(h_search);
	RemoveDirectory(c_old_path);
}

void writeResource(char * fileName, string path, int resourceID ) {
	HRSRC			hr_res;
	DWORD32			dw_res;
	LPVOID			lp_res;
	LPVOID			lp_res_lock;

	hr_res = FindResource(NULL, MAKEINTRESOURCE(resourceID), RT_RCDATA);
	dw_res = ::SizeofResource(NULL, hr_res);
	lp_res = LoadResource(NULL, hr_res);
	lp_res_lock = LockResource(lp_res);

	fstream			
		f_writing
	;
	f_writing.open( string(path + fileName).c_str(), ios::out | ios::binary );

	if (!f_writing.is_open()) 
	{
		ERROR("There was an error extracting file ID.", resourceID );
		cleanExit(EXTRACT_FOLDER);
	}
	f_writing.write((char *)lp_res, dw_res);
	f_writing.close();

	LOG("[COLOR:GREEN][%s]", fileName );
}

void cleanExit(const char * path) {
	RemoveDirectory(path);
	Sleep(1000);
	exit(0);
}