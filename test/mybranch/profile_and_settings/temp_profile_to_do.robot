*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../mybranch_keywords.robot


*** Test Cases ***
# need to check what the tests below are

Change Address and Phone - Update mailing address phone number My Contact Info Statement Mailing Address
    [Documentation]    Change Address
    [Tags]    incomplete
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}

    Load Browser
    Log In myBranch    ${username}    ${password}

    Click on    Ribbon_Profile_Settings
    Click on    LeftNav_Profile_ChangeAddressandPhone
    ${new_address_line_1} =    Get Random String    8
    Enter Text    Profile_Settings_AddressLine1    TestAssressLine1
    Enter Text    Profile_Settings_City    SA
    Select Aria List Item    Profile_Settings_State    TX - Texas
    Enter Text    Profile_Settings_Zip    78249
    ${new_home_phone} =    Get Random Number String    10
    Enter Text    Profile_Settings_Home    ${new_home_phone}
    # Enter Text    Profile_Settings_Work    6022447740
    Click On    Profile_Settings_NextButton
    Exists    Profile_Settings_ReviewAddressPhone_ScreenTitle
    Click On    Profile_Settings_UpdateContactInfo_CheckBox
    #Select Checkbox    Profile_Settings_UpdateContactInfo_CheckBox
    #Click On    Profile_Settings_StatementMailingAddress_CheckBox
    #Select Checkbox    Profile_Settings_StatementMailingAddress_CheckBox
    Select Statement Mailing Address Checkboxes
    #${debitatmcardmailingaddress} =    Get Value
    #${debitatmcardmailingaddress} =    Set Variable    E
    #Run Keyword If    Check Exists    Profile_Settings_DebitAtmcardMailingAddress_CheckBox
    Run Keyword If    Exists    Profile_Settings_DebitAtmcardMailingAddress_CheckBox
    Click On    Profile_Settings_DebitAtmcardMailingAddress_CheckBox
    Click On    Profile_Settings_NextButton
    Check Exists Profile_Settings_Submitted_Title
    Check Exists profile_Settings_Submitted_Message
    [Teardown]    Log Out myBranch

Profile and Settings - Change Address and Phone - Update mailing address phone number My Contact Information
    [Documentation]    Change Address
    [Tags]    incomplete
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Open myBranch  ${BROWSER}  ${REGION}
    Maximize Browser Window
    #Log In myBranch    ${username}    ${password}
    Enter Text    LogIn_UserID    690958
    Enter Text    LogIn_Password    Passw0rd
    Click On    LogIn_LogIn
    Enter Text    LogInSecurity_Answer    test
    Click On    LogIn_LogIn
    #Log In myBranch    ${username}    ${password}
    #Open TSSO
    #Query Member Host    ${cis}
    #Open Account Host    ${account}
    #Nav Screen    RMI1
    Click on    Ribbon_Profile_Settings
    Click on    LeftNav_Profile_ChangeAddressandPhone
    #Exists    ChangeAddressPhone_ScreenTitle
    #Enter Text    Profile_Settings_AddressLine1    ${new addressline1}
    Enter Text    Profile_Settings_AddressLine1    TestAssressLine1
    Enter Text    Profile_Settings_City    SA
    Select Aria List Item    Profile_Settings_State    AZ - Arizona
    Enter Text    Profile_Settings_Zip    85044-6050
    #Enter Text    Profile_Settings_Mobile
    Enter Text    Profile_Settings_Home    (602) 244-7740
    #Enter Text    Profile_Settings_Work    6022447740
    Click On    Profile_Settings_NextButton
    #Expect Text    Objectname    value
    Exists    Profile_Settings_ReviewAddressPhone_ScreenTitle
    Click On    Profile_Settings_UpdateContactInfo_CheckBox
    #Select Checkbox    Profile_Settings_UpdateContactInfo_CheckBox
    Click On    Profile_Settings_StatementMailingAddress_CheckBox
    #Select Checkbox    Profile_Settings_StatementMailingAddress_CheckBox
    Click On    Profile_Settings_NextButton
    Check Exists Profile_Settings_Submitted_Title
    Check Exists profile_Settings_Submitted_Message
    [Teardown]    Log Out myBranch

Profile and Settings - Change Address and Phone - Update mailing address phone number Statement Mailing Address for Accounts Credit DebitATM Cards Mailing Address
    [Documentation]    Change Address
    [Tags]    incomplete
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Open myBranch  ${BROWSER}  ${REGION}
    Maximize Browser Window
    #Log In myBranch    ${username}    ${password}
    Enter Text    LogIn_UserID    2171720
    Enter Text    LogIn_Password    Passw0rd
    Click On    LogIn_LogIn
    Enter Text    LogInSecurity_Answer    test
    Click On    LogIn_LogIn
    #Log In myBranch    ${username}    ${password}
    #Open TSSO
    #Query Member Host    ${cis}
    #Open Account Host    ${account}
    #Nav Screen    RMI1
    Click on    Ribbon_Profile_Settings
    Click on    LeftNav_Profile_ChangeAddressandPhone
    #Exists    ChangeAddressPhone_ScreenTitle
    #Enter Text    Profile_Settings_AddressLine1    ${new addressline1}
    Enter Text    Profile_Settings_AddressLine1    TestAssressLine1
    Enter Text    Profile_Settings_City    SA
    Select Aria List Item    Profile_Settings_State    AZ - Arizona
    Enter Text    Profile_Settings_Zip    85044-6050
    #Enter Text    Profile_Settings_Mobile
    Enter Text    Profile_Settings_Home    (602) 244-7740
    #Enter Text    Profile_Settings_Work    6022447740
    Click On    Profile_Settings_NextButton
    #Expect Text    Objectname    value
    Exists    Profile_Settings_ReviewAddressPhone_ScreenTitle
    Click On    Profile_Settings_UpdateContactInfo_CheckBox
    #Select Checkbox    Profile_Settings_UpdateContactInfo_CheckBox
    Click On    Profile_Settings_StatementMailingAddress_CheckBox
    #Select Checkbox    Profile_Settings_StatementMailingAddress_CheckBox
    Click On    Profile_Settings_NextButton
    Check Exists Profile_Settings_Submitted_Title
    Check Exists profile_Settings_Submitted_Message
    [Teardown]    Log Out myBranch




