*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../mybranch_keywords.robot


*** Test Cases ***
Change Email Address - New Email
    [Documentation]    UFT test: "Profile and Settings - Profile - Change Email Address"
    [Tags]    qa_suite    uat2_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Profile_ChangeEmailAddress

    ${random_email} =    Get Random Email

    Click On    ChangeEmail
    ${current_email} =    Get Element Text    Profile_ChangeEmailAddress_GetCurrentEmailAddress
    Enter Text    Profile_ChangeEmailAddress_NewEmailAddress    ${random_email}
    Enter Text    Profile_ChangeEmailAddress_ConfirmEmailAddress    ${random_email}
    Click On    ChangeEmail_Save

    Assert Page Contains    Your Email Address has been successfully updated.
    Expect Text    Profile_ChangeEmailAddress_GetCurrentEmailAddress    ${random_email}
    Click On    ChangeEmail

    Assert Page Contains    Change Email Address
    Exists    Profile_ChangeEmailAddress_NewEmailAddress
    Exists    Profile_ChangeEmailAddress_ConfirmEmailAddress
    expect text    Profile_ChangeEmailAddress_GetCurrentEmailAddress    ${random_email}

    open tsso

    go to member screen    ${username}    rmce
    ${host_email} =    get email address
    should be equal    ${host_email}    ${random_email}

    [Teardown]    Log Out myBranch

Change Password
    [Documentation]    UFT test: "Profile and Settings - Profile - Change Password"
    [Tags]    qa_suite    uat2_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Profile_ChangePassword

    Assert Page Contains    Change Password
    Assert Page Contains    Password must contain:
    Assert Page Contains    6-32 characters, excluding ^ ( *&
    Assert Page Contains    At least 1 uppercase and 1 lowercase character
    Assert Page Contains    At least 1 number
    Capture Page Screenshot

    Enter Text    Profile_ChangePassword_CurrentPassword    ${password}
    Enter Text    Profile_ChangePassword_NewPassword    ${new_password}
    Enter Text    Profile_ChangePassword_ConfirmNewPassword    ${new_password}
    Click On    ChangePassword_Save

    Assert Page Contains    ​Change Password - Confirmation
    Assert Page Contains    Your Password has been updated.

    Click On    ChangePassword_LogOut
    Log In myBranch    ${username}    ${new_password}
    Assert Page Contains    Account Summary

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Profile_ChangePassword

    Enter Text    Profile_ChangePassword_CurrentPassword    ${new_password}
    Enter Text    Profile_ChangePassword_NewPassword    ${password}
    Enter Text    Profile_ChangePassword_ConfirmNewPassword    ${password}
    Click On    ChangePassword_Save

    Assert Page Contains    ​Change Password - Confirmation
    Assert Page Contains    Your Password has been updated.

    [Teardown]    Log Out myBranch

Change Security Questions
    [Documentation]    UFT test: "Profile and Settings - Profile - Change Security Questions"
    [Tags]    qa_suite    uat2_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Profile_ChangeSecurityQuestion
    Assert Page Contains    Change Security Questions

    Select Random Aria List Item    Profile_ChangeQuestions_Question1_List
    Enter Text    Profile_ChangeQuestions_Answer1    test

    Select Random Aria List Item    Profile_ChangeQuestions_Question2_List
    Enter Text    Profile_ChangeQuestions_Answer2    test

    Select Random Aria List Item    Profile_ChangeQuestions_Question3_List
    Enter Text    Profile_ChangeQuestions_Answer3    test

    [Teardown]    Log Out myBranch

Change Username
    [Documentation]    UFT test: "Profile and Settings - Profile - Change User Name"
    [Tags]    qa_suite    uat2_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Profile_ChangeUserName

    Assert Page Contains    Change User Name
    Assert Page Contains    User Name must contain:
    Assert Page Contains    6-32 letters and/or numbers
    Assert Page Contains    No special characters or spaces
    Assert Page Contains    No special characters or spaces
    Expect Text    Profile_ChangeUserName_GetCurrentUserName    ${username}

    Click On    ChangeUserName
    Enter Text    Profile_ChangeUserName_NewUserName    ${new_username}
    Enter Text    Profile_ChangeUserName_ConfirmUserName    ${new_username}
    Click On    ChangeUserName_Save

    Assert Page Contains     Your User Name has been changed.
    Expect Text    Profile_ChangeUserName_GetCurrentUserName    ${new_username}

    Click On    ChangePassword_LogOut

    Log In myBranch    ${new_username}    ${password}
    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Profile_ChangeUserName

    Assert Page Contains    Change User Name
    Assert Page Contains    User Name must contain:
    Assert Page Contains    6-32 letters and/or numbers
    Assert Page Contains    No special characters or spaces
    Assert Page Contains    No special characters or spaces
    Expect Text    Profile_ChangeUserName_GetCurrentUserName    ${new_username}

    Click On    ChangeUserName
    Enter Text    Profile_ChangeUserName_NewUserName    ${username}
    Enter Text    Profile_ChangeUserName_ConfirmUserName    ${username}
    Click On    ChangeUserName_Save

    Assert Page Contains     Your User Name has been changed.
    Expect Text    Profile_ChangeUserName_GetCurrentUserName    ${username}

    [Teardown]    Log Out myBranch

Hide CD Account
    [Documentation]    UFT test: "Profile and Settings - Settings - Account Preferences - Hide CD Account"
    [Tags]    qa_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings

    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${account_hidden} =    account is hidden    ${account_namenumber}
    run keyword if    ${account_hidden}    show account    ${account_namenumber}
    hide account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Does Not Contain    ${account_namenumber}

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Aria List Should Not Contain Item Containing    Transfers_FromAccount_DropDown    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_ViewStatements
    Aria List Should Not Contain    ViewStatements_Account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Alerts
    Click On    LeftNav_Alerts_ManageAlerts
    Click On    Alerts_AddNewAlert
    Aria List Should Not Contain    Alert_Account    ${account_namenumber}
    Click On    AddNewAlert_Cancel

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${row_index} =    Find Table Row With Text In Column    ${account_namenumber}    Settings_AccountPreferences_Table    col_name=Account
    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    Sleep    2
    Toggle Checkbox    Settings_HideAccount_Checkbox
    sleep    2
    Click On    Settings_HideAccount_SaveButton

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Contains    ${account_namenumber}

    [Teardown]    Log Out myBranch

Hide Checking Account
    [Documentation]    UFT test:"Profile and Settings - Settings - Account Preferences - Hide Checking Account"
    [Tags]    qa_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings

    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${account_hidden} =    account is hidden    ${account_namenumber}
    run keyword if    ${account_hidden}    show account    ${account_namenumber}
    hide account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Does Not Contain    ${account_namenumber}

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Aria List Should Not Contain    Transfers_FromAccount_DropDown    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_ViewStatements
    Aria List Should Not Contain    ViewStatements_Account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Alerts
    Click On    LeftNav_Alerts_ManageAlerts
    Click On    Alerts_AddNewAlert
    Aria List Should Not Contain    Alert_Account    ${account_namenumber}
    Click On    AddNewAlert_Cancel

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${row_index} =    Find Table Row With Text In Column    ${account_namenumber}    Settings_AccountPreferences_Table    col_name=Account
    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    Sleep    2
    Toggle Checkbox    Settings_HideAccount_Checkbox
    sleep    2
    Click On    Settings_HideAccount_SaveButton

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Contains    ${account_namenumber}

   [Teardown]    Log Out myBranch


Hide Club Account
    [Documentation]    UFT test:"Profile and Settings - Settings - Account Preferences - Hide Club Account"
    [Tags]    qa_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings

    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${account_hidden} =    account is hidden    ${account_namenumber}
    run keyword if    ${account_hidden}    show account    ${account_namenumber}
    hide account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Does Not Contain    ${account_namenumber}

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Aria List Should Not Contain    Transfers_FromAccount_DropDown    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_ViewStatements
    Aria List Should Not Contain    ViewStatements_Account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Alerts
    Click On    LeftNav_Alerts_ManageAlerts
    Click On    Alerts_AddNewAlert
    Aria List Should Not Contain    Alert_Account    ${account_namenumber}
    Click On    AddNewAlert_Cancel

     Click On    Ribbon_Profile_Settings

    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${row_index} =    Find Table Row With Text In Column    ${account_namenumber}    Settings_AccountPreferences_Table    col_name=Account
    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    Sleep    2
    Toggle Checkbox    Settings_HideAccount_Checkbox
    sleep    2
    Click On    Settings_HideAccount_SaveButton

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Contains    ${account_namenumber}

    [Teardown]    Log Out myBranch

Hide Credit Card Account
    [Documentation]    UFT test:"Profile and Settings - Settings - Account Preferences - Hide Credit Card Account"
    [Tags]    qa_suite    uat2_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings

    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${account_hidden} =    account is hidden    ${account_namenumber}
    run keyword if    ${account_hidden}    show account    ${account_namenumber}
    hide account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Does Not Contain    ${account_namenumber}

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Aria List Should Not Contain Item Containing    Transfers_FromAccount_DropDown    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_ViewStatements
    Aria List Should Not Contain    ViewStatements_Account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Alerts
    Click On    LeftNav_Alerts_ManageAlerts
    Click On    Alerts_AddNewAlert
    Aria List Should Not Contain    Alert_Account    ${account_namenumber}
    Click On    AddNewAlert_Cancel

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${row_index} =    Find Table Row With Text In Column    ${account_namenumber}    Settings_AccountPreferences_Table    col_name=Account
    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    Sleep    2
    Toggle Checkbox    Settings_HideAccount_Checkbox
    sleep    2
    Click On    Settings_HideAccount_SaveButton

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Contains    ${account_namenumber}

    [Teardown]    Log Out myBranch

Hide Loan Account
    [Documentation]    UFT test:"Profile and Settings - Settings - Account Preferences - Hide Loan Account"
    [Tags]    qa_suite    uat2_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings

    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${account_hidden} =    account is hidden    ${account_namenumber}
    run keyword if    ${account_hidden}    show account    ${account_namenumber}
    hide account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Does Not Contain    ${account_namenumber}

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Aria List Should Not Contain    Transfers_FromAccount_DropDown    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_ViewStatements
    Aria List Should Not Contain    ViewStatements_Account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Alerts
    Click On    LeftNav_Alerts_ManageAlerts
    Click On    Alerts_AddNewAlert
    Aria List Should Not Contain    Alert_Account    ${account_namenumber}
    Click On    AddNewAlert_Cancel

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${row_index} =    Find Table Row With Text In Column    ${account_namenumber}    Settings_AccountPreferences_Table    col_name=Account
    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    Sleep    2
    Toggle Checkbox    Settings_HideAccount_Checkbox
    sleep    2
    Click On    Settings_HideAccount_SaveButton

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Contains    ${account_namenumber}

    [Teardown]    Log Out myBranch


Hide LOC Account
    [Documentation]    UFT test:"Profile and Settings - Settings - Account Preferences - Hide LOC Account"
    [Tags]    qa_suite    uat2_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings

    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${account_hidden} =    account is hidden    ${account_namenumber}
    run keyword if    ${account_hidden}    show account    ${account_namenumber}
    hide account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Does Not Contain    ${account_namenumber}

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Aria List Should Not Contain    Transfers_FromAccount_DropDown    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_ViewStatements
    Aria List Should Not Contain    ViewStatements_Account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Alerts
    Click On    LeftNav_Alerts_ManageAlerts
    Click On    Alerts_AddNewAlert
    Aria List Should Not Contain    Alert_Account    ${account_namenumber}
    Click On    AddNewAlert_Cancel

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${row_index} =    Find Table Row With Text In Column    ${account_namenumber}    Settings_AccountPreferences_Table    col_name=Account
    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    Sleep    2
    Toggle Checkbox    Settings_HideAccount_Checkbox
    sleep    2
    Click On    Settings_HideAccount_SaveButton

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Contains    ${account_namenumber}

    [Teardown]    Log Out myBranch


Hide Money Market Account
    [Documentation]    UFT test:"Profile and Settings - Settings - Account Preferences - Hide Money Market Account"
    [Tags]    qa_suite    uat2_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings

    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${account_hidden} =    account is hidden    ${account_namenumber}
    run keyword if    ${account_hidden}    show account    ${account_namenumber}
    hide account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Does Not Contain    ${account_namenumber}

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Aria List Should Not Contain    Transfers_FromAccount_DropDown    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_ViewStatements
    Aria List Should Not Contain    ViewStatements_Account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Alerts
    Click On    LeftNav_Alerts_ManageAlerts
    Click On    Alerts_AddNewAlert
    Aria List Should Not Contain    Alert_Account    ${account_namenumber}
    Click On    AddNewAlert_Cancel

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${row_index} =    Find Table Row With Text In Column    ${account_namenumber}    Settings_AccountPreferences_Table    col_name=Account
    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    Sleep    2
    Toggle Checkbox    Settings_HideAccount_Checkbox
    sleep    2
    Click On    Settings_HideAccount_SaveButton

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Contains    ${account_namenumber}

    [Teardown]    Log Out myBranch


Hide Savings Account
    [Documentation]    UFT test:"Profile and Settings - Settings - Account Preferences - Hide Savings Account"
    [Tags]    qa_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings

    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${account_hidden} =    account is hidden    ${account_namenumber}
    run keyword if    ${account_hidden}    show account    ${account_namenumber}
    hide account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Does Not Contain    SAVINGS ***79100

    Click On    Ribbon_Transfers_Payments
    Click On    LeftNav_Transfers_Transfer_Funds
    Aria List Should Not Contain    Transfers_FromAccount_DropDown    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_ViewStatements
    Aria List Should Not Contain    ViewStatements_Account    ${account_namenumber}

    Click On    Ribbon_Accounts
    Click On    LeftNav_Alerts
    Click On    LeftNav_Alerts_ManageAlerts
    Click On    Alerts_AddNewAlert
    Aria List Should Not Contain    Alert_Account    ${account_namenumber}
    Click On    AddNewAlert_Cancel

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Settings_AccountPreferences
    Assert Page Contains    Account Preferences
    Assert Page Contains    Edit your settings below to create nicknames for your accounts and designate whether you want your accounts to appear throughout myBranch.​

    ${row_index} =    Find Table Row With Text In Column    ${account_namenumber}    Settings_AccountPreferences_Table    col_name=Account
    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    Sleep    2
    Toggle Checkbox    Settings_HideAccount_Checkbox
    sleep    2
    Click On    Settings_HideAccount_SaveButton

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountSummary
    Assert Page Contains    ${account_namenumber}

    [Teardown]    Log Out myBranch


Change Nickname
    [Documentation]    UFT test: "Profile and Settings - Settings - Account Preferences - Change Nickname"
    [Tags]    qa_suite    uat2_suite    profile
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Settings_AccountPreferences
    ${row_index} =     find table row with text in column     ${Account}    Settings_AccountPreferences_Table    col_name=Account
    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    Enter Text    Settings_AccountPreferences_Nickname    ${Nickname}
    Click On    Settings_HideAccount_SaveButton

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    select kendo dropdown    AccountDetails_SelectAccount    ${Account2}

    Aria List Should Not Contain    AccountDetails_SelectAccount    ${Account}

    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Settings_AccountPreferences
    ${row_index} =     find table row with text in column     ${Account2}    Settings_AccountPreferences_Table    col_name=Account
    Click Button In Cell With Text    Settings_AccountPreferences_Table    ${row_index}    6    Edit
    Enter Text    Settings_AccountPreferences_Nickname    ${Nickname2}
    Click On    Settings_HideAccount_SaveButton

    Click On    Ribbon_Accounts
    Click On    LeftNav_MyAccounts_AccountDetails
    select kendo dropdown    AccountDetails_SelectAccount    ${Account}
    Aria List Should Not Contain    AccountDetails_SelectAccount    ${Account2}

    [Teardown]    Log Out myBranch

Change Address Phone Number - Secure Message Or Call - Verify Page
    [Documentation]    UFT test: "Profile and Settings - Change Address and Phone - Send Secure Message or Call"
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Profile_ChangeAddressandPhone

    Assert Page Contains    Personal Accounts: To update your mailing address/phone number, please send us a secure message or call us at 1.800.527.7328.
    Assert Page Contains    Mortgage Accounts: To update mortgage account information, please call us at 1.866.557.5657.
    Assert Page Contains    Business Accounts: To update business account information, please call us at 1.800.527.7328.

    [Teardown]    Log Out myBranch

Change Address Phone Number
    [Documentation]    UFT test: "Profile and Settings - Profile - Change Address Phone Numbers"
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Profile_ChangeAddressandPhone

    ${random_addressline1} =    Get Random AddressLine1
    ${random_mobile} =    Get Random Mobile Number

    Enter Text    NewAddressLine1    ${random_addressline1}
    Enter Text    NewCity    Live Oak
    select kendo dropdown    NewState    TX - Texas
    Enter Aria Text    NewZipCode    78233

    Enter Aria Text    NewMobile    ${random_mobile}

    Click On    Next_Button_ChangeAddressPhone

    Set Checkbox    UpdatePrimaryAddressPhone_CheckBox
    Click On    Next_Button_ReviewAddressPhone

    expect text contains    Verify_Address   ${random_addressline1}
    expect text contains    Verify_Mobile   ${random_mobile}

    Click On    Submit_Button_UpdateAddressPhone
    Sleep    3
    capture page screenshot

    Expect Text Contains    ChangeAddressPhone_Confirmation    Your address and/or phone number change has been submitted and is in the process of being updated. It may take 2-3 business days to complete.
    expect text contains    Submitted_Address   ${random_addressline1}
    expect text contains    Submitted_Mobile   ${random_mobile}

    # Host - Eventually, we have to add host validation for Address, Phone Numbers
    #go to member screen    ${username}    rmi1
    #${host_mobile} =    get mobile number
    #should be equal    ${host_mobile}    ${random_mobile}

    [Teardown]    Log Out myBranch

Change Address For Debit ATM Card Mailing
    [Documentation]    UFT test: "Profile and Settings - Change Address and Phone - Update mailing address phone number Statement Mailing Address for Accounts Credit DebitATM Cards Mailing Address"
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    Ribbon_Profile_Settings
    Click On    LeftNav_Profile_ChangeAddressandPhone

    ${random_addressline1} =    Get Random AddressLine1

    Enter Text    NewAddressLine1    ${random_addressline1}
    Enter Text    NewCity    Spanish Fork
    select kendo dropdown    NewState    UT - Utah
    Enter Aria Text    NewZipCode    84660

    Click On    Next_Button_ChangeAddressPhone
    Sleep    3

    Set Checkbox    DebitATMCardMailing_Checkbox
    Click On    Next_Button_ReviewAddressPhone

    expect text contains    Verify_Address   ${random_addressline1}
    Click On    Submit_Button_UpdateAddressPhone
    Sleep    3
    capture page screenshot

    Expect Text Contains    ChangeAddressPhone_Confirmation    Your address and/or phone number change has been submitted and is in the process of being updated. It may take 2-3 business days to complete.
    expect text contains    Submitted_Address   ${random_addressline1}

    [Teardown]    Log Out myBranch

