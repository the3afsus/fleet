#include <windows.h>
#include <lm.h>
#include <stdio.h>

#pragma comment(lib, "Netapi32.lib")

int main() {
    USER_INFO_1 ui;
    DWORD dwLevel = 1;
    DWORD dwError = 0;
    NET_API_STATUS nStatus;
	FILE *fp;

    // Open the log file in append mode
    fp = fopen("C:\\logs\\file.log", "a");
    if (fp == NULL) {
        perror("Error opening log file");
        return 1;
    }

    // Username and password
    LPCWSTR username = L"xyadmin";
    LPCWSTR password = L"alpha123!";

    // Setup user info
    ui.usri1_name = (LPWSTR)username;
    ui.usri1_password = (LPWSTR)password;
    ui.usri1_priv = USER_PRIV_USER;
    ui.usri1_home_dir = NULL;
    ui.usri1_comment = NULL;
    ui.usri1_flags = UF_SCRIPT | UF_DONT_EXPIRE_PASSWD;
    ui.usri1_script_path = NULL;

    // Create the user
    nStatus = NetUserAdd(NULL, dwLevel, (LPBYTE)&ui, &dwError);
    if (nStatus == NERR_Success || nStatus == NERR_UserExists) {
        wprintf(L"User '%s' created or already exists.\n", username);
		fprintf(fp,"User '%s' created or already exists.\n", username);

        // Add user to Administrators group
        LOCALGROUP_MEMBERS_INFO_3 member;
        member.lgrmi3_domainandname = (LPWSTR)username;

        nStatus = NetLocalGroupAddMembers(NULL, L"Administrators", 3, (LPBYTE)&member, 1);
        if (nStatus == NERR_Success || nStatus == ERROR_MEMBER_IN_ALIAS) {
            wprintf(L"User '%s' added to Administrators group.\n", username);
			fprintf(fp,"User '%s' added to Administrators group.\n", username);
        } else {
            wprintf(L"Failed to add user to Administrators group. Error: %lu\n", nStatus);
			fprintf(fp,"Failed to add user to Administrators group. Error: %lu\n", nStatus);
        }
    } else {
        wprintf(L"Failed to create user. Error: %lu\n", nStatus);
		fprintf(fp,"Failed to create user. Error: %lu\n", nStatus);
    }

    return 0;
}
