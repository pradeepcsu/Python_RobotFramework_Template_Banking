*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Library           Host
Resource          ../../mybranch_keywords.robot

*** Test Cases ***


Statements - Statement Delivery Preferences Paper Save
    [Documentation]    Test to verify the statement delivery preferences to paper
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_StatementsPreferences
    select delivery preference    ${account_namenumber}    StatementsDeliveryPreferencesTable    paper
    Exists    StatementPreferences_ChangePrefWindow
    Exists    StatementPreference_Paper_SaveButton
    Exists    StatementPreferences_Cancel
    Click On    StatementPreference_Paper_SaveButton
    Assert Page Contains    Your Statement Preference has been updated to Paper for account
    Click On    StatementPreference_Paper_CloseButton
    #Cleanup
    select delivery preference    ${account_namenumber}    StatementsDeliveryPreferencesTable
    Click On    StatementPreference_ChangeStatement_CheckBox
    Click On    StatementPreference_Paper_SaveButton
    Click On    StatementPreference_Paper_CloseButton

    [Teardown]    Log Out myBranch

Statements - Statement Delivery Preferences Paper Cancel
    [Documentation]    Test to verify the statement delivery preferences to paper
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_StatementsPreferences
    select delivery preference    ${account_namenumber}    StatementsDeliveryPreferencesTable    paper
    Exists    StatementPreferences_ChangePrefWindow
    Exists    StatementPreference_Paper_SaveButton
    Exists    StatementPreferences_Cancel
    Click On    StatementPreferences_Cancel
    Assert Page Contains    Statement Delivery Preferences

    [Teardown]    Log Out myBranch

Statements - Verify Statement Delivery Preferences
    [Documentation]    Test to verify the statement delivery preferences to paper
    [Tags]    new_test
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Log In myBranch    ${username}    ${password}
    Click On    LeftNav_Statements
    Click On    LeftNav_Statements_StatementsPreferences
    select delivery preference    ${account_namenumber}    StatementsDeliveryPreferencesTable    paper
    Exists    StatementPreferences_ChangePrefWindow
    Exists    StatementPreference_Paper_SaveButton
    Assert Page Contains    I understand I will be charged a $3 monthly paper statement fee for this service
    Click On    StatementPreferences_Cancel
    Assert Page Contains    Statement Delivery Preferences

    [Teardown]    Log Out myBranch
