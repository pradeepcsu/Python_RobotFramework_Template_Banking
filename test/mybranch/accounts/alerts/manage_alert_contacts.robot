*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../../mybranch_keywords.robot

*** Test Cases ***
Manage Contacts - Add New Contact
    [Documentation]    Manage Alert Contacts - Add a new contact.
    [Tags]    qa_suite    manage_alert    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    # Open myBranch    ${BROWSER}    ${REGION}
    #Load Browser
    Log In myBranch    ${username}    ${password}
    Go To Manage Alert Contact
    ${name} =    Set Variable    Test Contact
    ${email} =    Set Variable    tester@ssfcu.org
    ${existing} =    Count Alert Contacts    Test Contact    tester@ssfcu.org
    Click On    Alerts_AddNewContact
    Sleep    2
    Enter Text    Alerts_AddNewContact_Name    Test Contact
    Enter Text    Alerts_AddNewContact_Email    tester@ssfcu.org
    Enter Text    Alerts_AddNewContact_ConfirmEmail    tester@ssfcu.org
    Capture Page Screenshot
    Click On    Alerts_AddNewContact_AddContact
    Exists    Alerts_AddNewContact_Confirmation
    Capture Page Screenshot
    Click On    Alerts_AddNewContact_Close
    ${recount} =    Count Alert Contacts    Test Contact    tester@ssfcu.org
    ${expected} =    Evaluate    ${existing} + ${1}
    Should Be Equal As Integers    ${expected}    ${recount}
    Capture Page Screenshot
    ${row} =    Get Last Alert Contact
    Click Delete Alert Contact    ${row}
    Expect Text    Alerts_DeleteContact_Name    Test Contact
    Expect Text    Alerts_DeleteContact_Email    tester@ssfcu.org
    Click On    Alerts_DeleteContact_Delete
    Exists    Alerts_DeleteContact_Confirmation
    Capture Page Screenshot
    Click On    Alerts_DeleteContact_Close
    ${recount} =    Count Alert Contacts    Test Contact    tester@ssfcu.org
    Should Be Equal As Integers    ${existing}    ${recount}
    [Teardown]    Log Out myBranch

Manage Contacts - Edit Email
    [Documentation]    Manage Alert Contacts - Edit an existing contact.
    [Tags]    qa_suite    manage_alert    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    #Load Browser
    Log In myBranch    ${username}    ${password}
    Go To Manage Alert Contact
    Capture Page Screenshot
    ${row} =    Get Random Alert Contact
    ${name} =    Get Alert Contact Name    ${row}
    Click Edit Alert Contact    ${row}
    Expect Text    Alerts_EditContact_Name    ${name}
    ${old email} =    Get Element Text    Alerts_EditContact_Email
    ${new email} =    Get Random Email
    Enter Text    Alerts_EditContact_Email    ${new email}
    Enter Text    Alerts_EditContact_ConfirmEmail    ${new email}
    Click On    Alerts_AddNewContact_AddContact
    Exists    Alerts_DeleteContact_Confirmation
    Capture Page Screenshot
    Click On    Alerts_DeleteContact_Close
    Verify Alert Contact    ${row}    ${name}    ${new email}
    [Teardown]    Log Out myBranch