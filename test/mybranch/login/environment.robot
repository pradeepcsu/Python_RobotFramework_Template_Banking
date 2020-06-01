*** Settings ***
Library           Selenium2Library
Library           Screenshot
Library           MyBranch
Resource          ../mybranch_keywords.robot


*** Test Cases ***
Login - Assembly File Version
    [Documentation]    Verify the message "Assembly File Version ..." does not appear in QAT. This test is only to be run in the QA region.
    [Tags]    qa_suite    new_test    smoke    negative   sit
    [Setup]    Load Test Data    mybranch    ${TEST NAME}    ${REGION}
    Load Browser
    Maximize Browser Window
    Assert Page Contains    Log In
    Page Should Not Contain    Assembly File Version
    Capture Page Screenshot
